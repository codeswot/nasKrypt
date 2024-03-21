import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:naskrypt/view/page/movie/movie_home.dart';
import 'package:path_provider/path_provider.dart';

class VideoService {
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

  startProcess(String inputVideoPath) async {
    // final Dio dio = Dio();
    // await dio.get('http://localhost:54103/hello-mate',
    //     data: {"data": "Hello,world!"});
    final docDir = await getApplicationDocumentsDirectory();
    final outputDirectory = '${docDir.path}/output';
    await Directory(outputDirectory).create(recursive: true);
    final workDirectory = await workDir;
    final inputFile =
        await File(inputVideoPath).copy('$workDirectory/input.mp4');
    await inputFile.create();

    final playlistFile =
        await File('$outputDirectory/playlist.m3u8').create(recursive: true);

    final playlistEntries = <String>[];
    const segmentDuration = 10;
    final totalDuration = await getVideoDuration(inputFile.absolute.path);
    final numSegments = (totalDuration / segmentDuration).ceil();
    for (var i = 0; i < numSegments; i++) {
      final startTime = i * segmentDuration;
      final endTime = (i + 1) * segmentDuration;

      final segmentPath = '$outputDirectory/chunk_$i.ts';
      await segmentVideo(inputFile.path, segmentPath, startTime, endTime);
      playlistEntries.add('chunk_$i.ts');

      await playlistFile.writeAsString(
          '#EXTM3U\n#EXT-X-VERSION:3\n${playlistEntries.map((entry) => '#EXTINF:$segmentDuration,\n$entry').join('\n')}');
    }

    if (kDebugMode) {
      print('Video segmentation completed! work dir $workDirectory');
    }
  }

  Future<double> getVideoDuration(String videoPath) async {
    // final workDirectory = await workDir;
    final command =
        'ffmpeg ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $videoPath';
    final isPathSet = await _setFFmpegPath();
    if (isPathSet) {
      final result = await _ffmpegCommand(command: command);
      //

      final duration = double.tryParse(result.stdout.trim());
      if (duration == null) {
        throw Exception('Failed to parse video duration');
      }

      return duration;
    }

    return 0;
  }

  Future<void> segmentVideo(
      String inputPath, String outputPath, int startTime, int endTime) async {
    final result = await Process.run('ffmpeg', [
      '-y',
      '-i',
      inputPath,
      '-ss',
      '$startTime',
      '-to',
      '$endTime',
      '-c',
      'copy',
      outputPath
    ]);

    if (result.exitCode != 0) {
      throw Exception('Failed to segment video: ${result.stderr}');
    }
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
    final ffmpegDir = '$workDirectory/utils/macos/ffmpeg';
    //
    await _makeFileExecutable(ffmpegDir);
    //
    final setPath = 'export PATH=\$PATH:$ffmpegDir';
    final pathRes = await Process.run(
      'sh',
      ['-c', setPath],
      runInShell: false,
    );
    print('ST-OUT: ${pathRes.stdout}');
    if (pathRes.exitCode == 0) return true;
    return false;
  }
}

Future<void> _makeFileExecutable(String filePath) async {
  if (Platform.isLinux || Platform.isMacOS) {
    final processResult = await Process.run('chmod', ['+x', filePath]);

    if (processResult.exitCode != 0) {
      print('Error when making the file executable: ${processResult.stderr}');
    }
  } else {
    print('Not making the file executable on Windows');
  }
}
