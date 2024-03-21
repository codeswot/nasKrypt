import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:pointycastle/pointycastle.dart';

class EncryptionService {
  Future encryptFile(String inputPath) async {
    final inputFile = File(inputPath);
    if (!inputFile.existsSync()) throw 'File not found';
    var key = utf8.encode('p@ssw0rd');
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
    var key = utf8.encode('p@ssw0rd');

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
}
