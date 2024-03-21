import 'dart:async';
import 'dart:io';

import 'package:encrypt/encrypt.dart' as enc;

class EncryptionService {
  var key = enc.Key.fromUtf8('J1kBGAa1LzX2y3UWFO4tRY31kO6ydOj7');
  var iv = enc.IV.fromUtf8("RiveW1ancahl11fa");
  Future encryptFile(String inputPath) async {
    File inputFile = File(inputPath);
    if (!inputFile.existsSync()) throw 'File not found';
    final encrypter = enc.Encrypter(enc.AES(key));

    final encryptedData =
        encrypter.encryptBytes(inputFile.readAsBytesSync(), iv: iv);
    final encryptedBytes = encryptedData.bytes;
    final outputFile = File(inputPath.replaceFirst('.ts', '_encrypted.ts'));
    outputFile.writeAsBytesSync(encryptedBytes);
  }

  Future decryptFile(String inputPath) async {
    final inputFile = File(inputPath);
    if (!inputFile.existsSync()) throw 'File not found';
    final encrypter = enc.Encrypter(enc.AES(key));
    final decryptedData = encrypter
        .decryptBytes(enc.Encrypted(inputFile.readAsBytesSync()), iv: iv);
    final decryptedBytes = decryptedData;
    final outputFile = File(inputPath.replaceFirst('_encrypted.ts', '.ts'));
    outputFile.writeAsBytesSync(decryptedBytes);
  }
}
