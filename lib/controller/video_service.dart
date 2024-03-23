import 'dart:convert';
import 'dart:io';

// import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:naskrypt/controller/encryption_service.dart';
import 'package:naskrypt/view/page/movie/movie_home.dart';
import 'package:path_provider/path_provider.dart';

class VideoService {
  final EncryptionService encryptionService = EncryptionService();
  Future<String> get workDir => _workDir();
  Future prepareWorkDirectory() async {
    final workDirectory = await workDir;
    // create output dir
    final outPutDir = Directory('$workDirectory/output');
    if (await outPutDir.exists() == false) {
      await outPutDir.create(recursive: true);
    }
    // create utils dir
    final utilsDir = Directory('$workDirectory/.utils');
    if (await utilsDir.exists() == false) {
      await utilsDir.create(recursive: true);
    }
    if (Platform.isLinux) {
      // create ffmpeg dir
      final ffmpegDir = Directory('${utilsDir.path}/linux');
      if (await ffmpegDir.exists() == false) {
        await ffmpegDir.create(recursive: true);
        final File ffmpegFile = File('${utilsDir.path}/linux/FFmpeg_linux.xz');
        final data = await rootBundle.load('assets/utils/FFmpeg_linux.xz');
        await ffmpegFile.writeAsBytes(data.buffer.asUint8List());
        // unzip FFmpeg_linux.xz
        await Process.run('xz', ['x', ffmpegFile.path, '-o${ffmpegDir.path}']);
        await ffmpegFile.delete();
      }
    } else if (Platform.isMacOS) {
      // create ffmpeg dir
      final ffmpegDir = Directory('${utilsDir.path}/macos');
      if (await ffmpegDir.exists() == false) {
        await ffmpegDir.create(recursive: true);
        final File ffmpegFile = File('${utilsDir.path}/macos/ffmpeg_macos.7z');
        final data = await rootBundle.load('assets/utils/ffmpeg_macos.7z');
        await ffmpegFile.writeAsBytes(data.buffer.asUint8List());

        await Process.run('7z', ['x', ffmpegFile.path, '-o${ffmpegDir.path}']);

        await ffmpegFile.delete();
      }
    } else {
      throw Exception('Unsupported platform');
    }
    //
  }

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
    final inputFile = await File(inputVideoPath).copy(
        '$workDirectory/${inputVideoPath.split('/').last.replaceAll(' ', '_')}');
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
    final infoOutPutForContent = File('$mediaPlayContentOutput/info.json');

    if (!infoOutPutForContent.existsSync()) {
      infoOutPutForContent.createSync();
    }
    if (!infoOutPut.existsSync()) {
      infoOutPut.createSync();
    }
    final movieInfoJson = movieInfo.toJson();
    await infoOutPut.writeAsString(jsonEncode(movieInfoJson));
    await infoOutPutForContent.writeAsString(jsonEncode(movieInfoJson));
    if (kDebugMode) {
      print('Video segmentation completed! work dir $workDirectory');
    }
    await generateThumbnail(inputFile.path, mediaPlayContentOutput);
    await generateThumbnail(inputFile.path, mediaOutput);

    await zipContent(mediaPlayContentOutput);
    await inputFile.delete(recursive: true);
  }

  Future<double> getVideoDuration(String videoPath) async {
    final workDirectory = await workDir;
    // print("work dir $workDirectory");file:///home/ultrondebugs/Documents/output/playlist.m3u8

    final command =
        '$workDirectory/utils/linux/ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $videoPath';
    final isPathSet = await _setFFmpegPath();
    if (isPathSet) {
      final result = await _runCommand(command: command);
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
    if (kDebugMode) {
      print("output path>>>> $outputPath");
    }

    final command =
        '$workDirectory/utils/linux/ffmpeg -i $inputPath -c:v copy -c:a copy -hls_list_size 0 -hls_time 6 -hls_segment_filename $outputPath/${inputPath.split('/').last}%d.ts -y $outputPath/playlist.m3u8';
    final result = await _runCommand(command: command);

    if (kDebugMode) {
      print("object $result");
    }
  }

  Future<dynamic> _runCommand({required String command}) async {
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

    final result = await _runCommand(command: command);

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

  Future<List<Directory>> getFoldersInOutputDirectory() async {
    final workDirectory = await workDir;
    final outputDirectory = '$workDirectory/output/';
    final directory = Directory(outputDirectory);
    if (!directory.existsSync()) throw 'Directory not found';
    final subDirectories = directory.listSync().whereType<Directory>();
    return subDirectories.toList();
  }

  Future<MovieInfo> getMovieContentInfo(String moviePath) async {
    final directory = Directory(moviePath);
    if (!directory.existsSync()) throw 'Directory not found';
    final infoFile = File('$moviePath/info.json');
    if (!infoFile.existsSync()) throw 'File not found';
    final content = await infoFile.readAsString();
    final movieInfoJson = jsonDecode(content);
    final movieInfo = MovieInfo.fromJson(movieInfoJson);
    return movieInfo;
  }

  Future zipContent(String contentPath) async {
    final workDirectory = await workDir;
    final command =
        'cd $contentPath && zip -r $contentPath.zip * && cd $workDirectory';
    final result = await _runCommand(command: command);

    final contentDirectory = Directory(contentPath);
    contentDirectory.deleteSync(recursive: true);
    if (kDebugMode) {
      print("object $result");
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
