import 'dart:convert';
import 'dart:io';

// import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:naskrypt/controller/encryption_service.dart';
import 'package:naskrypt/model/content_info.dart';
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
        final File ffmpegFile = File('${utilsDir.path}/linux/ffmpeg_linux.zip');
        final File cryptoFile = File('${utilsDir.path}/linux/cryptoScript.sh');
        final cryptoData = await rootBundle.load('assets/utils/cryptoScript.sh');
        final data = await rootBundle.load('assets/utils/ffmpeg_linux.zip');
        await ffmpegFile.writeAsBytes(data.buffer.asUint8List());
        await cryptoFile.writeAsBytes(cryptoData.buffer.asUint8List());

        // unzip FFmpeg_linux.xz        await Process.run('unzip', [(ffmpegFile.path), '-d', (ffmpegDir.path)]);
        await Process.run('unzip', [(ffmpegFile.path), '-d', (ffmpegDir.path)]);

        await ffmpegFile.delete();
      }
    } else if (Platform.isMacOS) {
      // create ffmpeg dir
      final ffmpegDir = Directory('${utilsDir.path}/macos');
      if (await ffmpegDir.exists() == false) {
        await ffmpegDir.create(recursive: true);
        final File ffmpegFile = File('${ffmpegDir.path}/ffmpeg_macos.zip');
        final data = await rootBundle.load('assets/utils/ffmpeg_macos.zip');
        await ffmpegFile.writeAsBytes(data.buffer.asUint8List());

        await ZipFile.extractToDirectory(zipFile: ffmpegFile, destinationDir: ffmpegDir);

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

  startProcess(ContentInfo contentInfo) async {
    int runtime = 0;
    // final Dio dio = Dio();
    // await dio.get('http://localhost:54103/hello-mate',
    //     data: {"data": "Hello,world!"});
    final inputVideoPath = contentInfo.contentPath;
    if (inputVideoPath == null) {
      throw Exception('No input video path');
    }
    if (!File(inputVideoPath).existsSync()) {
      throw Exception('Input video path does not exist');
    }
    final docDir = await getApplicationDocumentsDirectory();
    final outputDirectory = '${docDir.path}/work/output';
    await Directory(outputDirectory).create(recursive: true);
    final workDirectory = await workDir;
    final inputFile =
        await File(inputVideoPath).copy('$workDirectory/${inputVideoPath.split('/').last.replaceAll(' ', '_')}');
    await inputFile.create();

    String mediaOutput = '$outputDirectory/${inputFile.path.split('/').last.split('.').first}';
    var dir = Directory(mediaOutput);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    String mediaPlayContentOutput = '$mediaOutput/content';
    Directory playDir = Directory(mediaPlayContentOutput);
    if (!playDir.existsSync()) {
      playDir.createSync(recursive: true);
    }
    if (Platform.isLinux) {
      await segmentVideo(inputFile.path, mediaPlayContentOutput);
      if (kDebugMode) {
        print('starting enryption...');
      }
      runtime = await getVideoDurationInMilliseconds(inputFile.path);
    }

    // await encryptContents(mediaPlayContentOutput);

    final infoOutPut = File('$mediaOutput/info.json');
    final infoOutPutForContent = File('$mediaPlayContentOutput/info.json');

    if (!infoOutPutForContent.existsSync()) {
      infoOutPutForContent.createSync();
    }
    if (!infoOutPut.existsSync()) {
      infoOutPut.createSync();
    }

    final movieInfoJson = contentInfo.copyWith(runtimeInMilli: runtime).toJson();
    await infoOutPut.writeAsString(jsonEncode(movieInfoJson));
    await infoOutPutForContent.writeAsString(jsonEncode(movieInfoJson));
    if (kDebugMode) {
      print('Video segmentation completed! work dir $workDirectory');
    }
    await generateThumbnail(inputFile.path, mediaPlayContentOutput, contentInfo.thumbnailPath);
    await generateThumbnail(inputFile.path, mediaOutput, contentInfo.thumbnailPath);

    await zipContent(mediaPlayContentOutput);
    await inputFile.delete(recursive: true);
  }

  Future<int> getVideoDurationInMilliseconds(String inputPath) async {
    final workDirectory = await workDir;

    final command =
        '$workDirectory/.utils/linux/ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $inputPath';
    final result = await _runCommand(command: command);
    final durationInSeconds = double.parse(result.trim());
    final durationInMilliseconds = (durationInSeconds * 1000).toInt();
    return durationInMilliseconds;
  }

  Future<void> segmentVideo(String inputPath, String outputPath) async {
    final workDirectory = await workDir;
    if (kDebugMode) {
      print("output path>>>> $outputPath");
    }
    String fileName = inputPath.split('/').last.split('.').first;

    final command =
        '$workDirectory/.utils/linux/ffmpeg -i $inputPath -c:v copy -c:a copy -hls_list_size 0 -hls_time 6 -hls_segment_filename $outputPath/$fileName%d.ts -y $outputPath/$fileName.m3u8';
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

  Future<void> generateThumbnail(String inputPath, String outputDirectory, String? thumbnailPath) async {
    final workDirectory = await workDir;

    if (thumbnailPath == null) {
      final command =
          '$workDirectory/.utils/linux/ffmpeg -i $inputPath -ss 00:00:20 -vframes 1 $outputDirectory/thumbnail.jpg';
      final result = await _runCommand(command: command);
      if (kDebugMode) {
        print("Thumbnail and Poster generated generated $result");
      }
    } else {
      final thumbFile = File(thumbnailPath);
      if (!thumbFile.existsSync()) {
        if (Platform.isLinux) {
          final command =
              '$workDirectory/.utils/linux/ffmpeg -i $inputPath -ss 00:00:20 -vframes 1 $outputDirectory/thumbnail.jpg';
          await _runCommand(command: command);
        }
      } else {
        await thumbFile.copy('$outputDirectory/thumbnail.jpg');
      }
    }

    if (Platform.isLinux) {
      final command2 =
          '$workDirectory/.utils/linux/ffmpeg -i $inputPath -ss 00:00:30 -vframes 1 $outputDirectory/poster.jpg';
      await _runCommand(command: command2);
    }
  }

  encryptContents(mediaPlayContentOutput) async {
    final directory = Directory(mediaPlayContentOutput);
    if (!directory.existsSync()) throw 'Directory not found';
    final tsFiles = directory.listSync().whereType<File>().where((file) => file.path.endsWith('.ts'));
    for (var tsFile in tsFiles) {
      final inputPath = tsFile.path;
      // String command =
      //     '${await workDir}/.utils/linux/cryptoScript.sh encrypt $inputPath';
      // await _runCommand(
      //     command: ' chmod +x ${await workDir}/.utils/linux/cryptoScript.sh');
      // await _runCommand(command: command);

      await encryptionService.encryptFile(inputPath);
      tsFile.deleteSync();
    }
  }

  decryptContents(mediaPlayContentOutput) async {
    final directory = Directory(mediaPlayContentOutput);
    if (!directory.existsSync()) throw 'Directory not found';
    final tsFiles = directory.listSync().whereType<File>().where((file) => file.path.endsWith('_encrypted.ts'));
    for (var tsFile in tsFiles) {
      final inputPath = tsFile.path;

      // String command =
      //     '$workDir/.utils/linux/cryptoScript.sh decrypt $inputPath';

      // await _runCommand(command: command);

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

  Stream<List<Directory>> getFoldersInOutputDirectory$() async* {
    final workDirectory = await workDir;
    final outputDirectory = '$workDirectory/output/';
    final directory = Directory(outputDirectory);

    if (!directory.existsSync()) {
      throw 'Directory not found';
    }

    final subDirectories = directory.listSync().whereType<Directory>().toList();

    yield subDirectories;
  }

  Future<ContentInfo> getMovieContentInfo(String moviePath) async {
    final directory = Directory(moviePath);
    if (!directory.existsSync()) throw 'Directory not found';
    final infoFile = File('$moviePath/info.json');
    if (!infoFile.existsSync()) throw 'File not found';
    final content = await infoFile.readAsString();
    final movieInfoJson = jsonDecode(content);
    final movieInfo = ContentInfo.fromJson(movieInfoJson);
    return movieInfo;
  }

  Future zipContent(String contentPath) async {
    // final workDirectory = await workDir;
    final sourceDir = Directory(contentPath);
    if (!sourceDir.existsSync()) return;
    // final files = sourceDir.listSync().whereType<File>().toList();

    // final zipFile = File('$contentPath.zip');
    // if (!zipFile.existsSync()) zipFile.createSync();

    try {
      String command = "zip -jr $contentPath.zip $contentPath";
      await _runCommand(command: command);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    sourceDir.deleteSync(recursive: true);
    if (kDebugMode) {
      //
    }
  }

  Future<void> zipFromTo(Directory fromDirectory, String toDirectory) async {
    final fileName = fromDirectory.path.split('/').last;
    final zipFilePath = '$toDirectory/$fileName.zip';

    try {
      final result = await Process.run('zip', ['-jr', zipFilePath, fromDirectory.path]);

      if (result.exitCode == 0) {
        if (kDebugMode) {
          print('Directory successfully zipped to $zipFilePath with ${result.exitCode} and error ${result.stderr}');
        }
      } else {
        if (kDebugMode) {
          print('Directory failed to ZIP to $zipFilePath with ${result.exitCode} and error ${result.stderr}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}

Future<void> makeFileExecutable(String filePath) async {
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
