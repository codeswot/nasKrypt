import 'dart:convert';
import 'dart:io';

// import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:naskrypt/controller/encryption_service.dart';
import 'package:naskrypt/view/page/movie/movie_home.dart';
import 'package:path_provider/path_provider.dart';

class VideoService {
  final EncryptionService encryptionService = EncryptionService();
  Future<String> get workDir => _workDir();

  Future<String> _workDir() async {
    final docDir = await getApplicationDocumentsDirectory();
    final workDirectory = '${docDir.path}/work';
    final dir = Directory(workDirectory);
    if (await dir.exists() == false) {
      await Directory(workDirectory).create(recursive: true);
    }
    return workDirectory;
  }

  startProcess(String inputVideoPath, MovieInfo movieInfo) async {
    // final Dio dio = Dio();
    // await dio.get('http://localhost:54103/hello-mate',
    //     data: {"data": "Hello,world!"});
    final docDir = await getApplicationDocumentsDirectory();
    final outputDirectory = '${docDir.path}/work/output';
    await Directory(outputDirectory).create(recursive: true);
    final workDirectory = await workDir;
    final inputFile = await File(inputVideoPath)
        .copy('$workDirectory/${inputVideoPath.split('/').last}');
    await inputFile.create();

    //final totalDuration = await getVideoDuration(inputFile.absolute.path);
    String mediaOutput =
        '$outputDirectory/${inputFile.path.split('/').last.split('.').first}';
    var dir = Directory(mediaOutput);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    String mediaPlayContentOutput = '$mediaOutput/content';
    Directory playDir = Directory(mediaPlayContentOutput);
    if (!playDir.existsSync()) {
      playDir.createSync(recursive: true);
    }

    await segmentVideo(inputFile.path, mediaPlayContentOutput);
    await encryptContents(mediaPlayContentOutput);

    final infoOutPut = File('$mediaOutput/info.json');
    if (!infoOutPut.existsSync()) {
      infoOutPut.createSync();
    }
    final movieInfoJson = movieInfo.toJson();
    await infoOutPut.writeAsString(jsonEncode(movieInfoJson));
    if (kDebugMode) {
      print('Video segmentation completed! work dir $workDirectory');
    }
    await generateThumbnail(inputFile.path, mediaOutput);
  }

  Future<double> getVideoDuration(String videoPath) async {
    final workDirectory = await workDir;
    // print("work dir $workDirectory");file:///home/ultrondebugs/Documents/output/playlist.m3u8

    final command =
        '$workDirectory/utils/linux/ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $videoPath';
    final isPathSet = await _setFFmpegPath();
    if (isPathSet) {
      final result = await _ffmpegCommand(command: command);
      //

      final duration = double.tryParse(result.trim());
      if (kDebugMode) {
        print('video duration is $duration');
      }
      if (duration == null) {
        throw Exception('Failed to parse video duration');
      }

      return duration;
    }

    return 0;
  }

  Future<void> segmentVideo(String inputPath, String outputPath) async {
    final workDirectory = await workDir;
    print("output path>>>> $outputPath");

    final command =
        '$workDirectory/utils/linux/ffmpeg -i $inputPath -c:v copy -c:a copy -hls_list_size 0 -hls_time 6 -hls_segment_filename $outputPath/${inputPath.split('/').last}%d.ts -y $outputPath/playlist.m3u8';

    // '$workDirectory/utils/linux/ffmpeg -i $inputPath -c:v copy -c:a copy -hls_list_size 0 -hls_time 10 -hls_segment_filename ${inputPath.split('/').last}%d.ts -y $outputPath/${inputPath.split('/').last}.m3u8';

    // '$workDirectory/utils/linux/ffmpeg -i $inputPath -c copy -map 0 -segment_time 10 -f segment $outputPath';

    // '$workDirectory/utils/linux/ffmpeg -y -i $inputPath -ss $startTime -to $endTime -c copy $outputPath';
    final result = await _ffmpegCommand(command: command);

    print("object $result");
  }

  Future<dynamic> _ffmpegCommand({required String command}) async {
    final result = await Process.run('sh', [
      '-c',
      command,
    ]);
    if (result.exitCode != 0) {
      throw Exception('Failed to run command: ${result.stderr}');
    }
    return result.stdout;
  }

  Future<bool> _setFFmpegPath() async {
    final workDirectory = await workDir;
    final ffmpegDir = '$workDirectory/utils/linux/ffmpeg';
    final ffProbeDir = '$workDirectory/utils/linux/ffprobe';

    //
    await _makeFileExecutable(ffmpegDir);
    await _makeFileExecutable(ffProbeDir);
    //
    final setPath = 'export PATH=\$PATH:$ffmpegDir';
    final pathRes = await Process.run(
      'sh',
      ['-c', setPath],
      runInShell: false,
    );
    if (kDebugMode) {
      print('ST-OUT: ${pathRes.stdout}');
    }
    if (pathRes.exitCode == 0) return true;
    return false;
  }

  Future<void> generateThumbnail(
      String inputPath, String outputDirectory) async {
    final workDirectory = await workDir;

    final command =
        '$workDirectory/utils/linux/ffmpeg -i $inputPath -ss 00:00:20 -vframes 1 $outputDirectory/thumbnail.jpg';

    final result = await _ffmpegCommand(command: command);

    if (kDebugMode) {
      print("Thumbnail generated $result");
    }
  }

  encryptContents(mediaPlayContentOutput) async {
    final directory = Directory(mediaPlayContentOutput);
    if (!directory.existsSync()) throw 'Directory not found';
    final tsFiles = directory
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.ts'));
    for (var tsFile in tsFiles) {
      final inputPath = tsFile.path;

      await encryptionService.encryptFile(inputPath);
      tsFile.deleteSync();
    }
  }

  decryptContents(mediaPlayContentOutput) async {
    final directory = Directory(mediaPlayContentOutput);
    if (!directory.existsSync()) throw 'Directory not found';
    final tsFiles = directory
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('_encrypted.ts'));
    for (var tsFile in tsFiles) {
      final inputPath = tsFile.path;

      await encryptionService.decryptFile(inputPath);

      tsFile.deleteSync();
    }
  }
}

Future<void> _makeFileExecutable(String filePath) async {
  if (Platform.isLinux || Platform.isMacOS) {
    final processResult = await Process.run('chmod', ['+x', filePath]);

    if (processResult.exitCode != 0) {
      if (kDebugMode) {
        print('Error when making the file executable: ${processResult.stderr}');
      }
    }
  } else {
    if (kDebugMode) {
      print('Not making the file executable on Windows');
    }
  }
}
