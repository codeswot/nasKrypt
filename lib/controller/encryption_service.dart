import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:pointycastle/pointycastle.dart';

class EncryptionService {
  Future encryptFile(String inputPath) async {
    final inputFile = File(inputPath);
    if (!inputFile.existsSync()) throw 'File not found';

    final key = generateRandomKey();

    // var key = utf8.encode('uioPbJb97BKpdx7oX8XzmKkt0JljY4xWkV9/4xX7f3I=');
    final cipher = BlockCipher('AES')..init(true, KeyParameter(key));
    final inputBytes = await inputFile.readAsBytes();
    final encryptedBytes = cipher.process(Uint8List.fromList(inputBytes));
    if (kDebugMode) {
      print(
          'DIGEST ${cipher.algorithmName.toString()} and bytes $encryptedBytes');
    }
    final outputPath = inputPath.replaceFirst('.ts', '_encrypted.ts');
    final outputFile = File(outputPath);
    if (!outputFile.existsSync()) {
      await outputFile.create();
    }
    await outputFile.writeAsBytes(encryptedBytes);
  }

  Future decryptFile(String encryptedFilePath) async {
    final encryptedFile = File(encryptedFilePath);
    if (!encryptedFile.existsSync()) throw 'File not found';
    var key = utf8.encode('uioPbJb97BKpdx7oX8XzmKkt0JljY4xWkV9/4xX7f3I=');

    final cipher = BlockCipher('AES')..init(false, KeyParameter(key));
    final encryptedBytes = encryptedFile.readAsBytesSync();
    final decryptedBytes = cipher.process(Uint8List.fromList(encryptedBytes));
    if (kDebugMode) {
      print(
          'DIGEST ${cipher.algorithmName.toString()} and bytes $encryptedBytes');
    }
    final outputPath = encryptedFilePath.replaceFirst('_encrypted.ts', '.ts');
    final outputFile = File(outputPath);
    if (!outputFile.existsSync()) {
      await outputFile.create();
    }
    await outputFile.writeAsBytes(decryptedBytes);
  }

  Uint8List generateRandomKey() {
    final random = Random.secure();
    final key = List<int>.generate(32, (_) => random.nextInt(256));
    if (kDebugMode) {
      print('new key is $key');
    }
    return Uint8List.fromList(key);
  }
}
