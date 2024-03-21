import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

class EncryptionService {
  Future encrypt(String inputPath) async {
    final inputFile = File(inputPath);
    if (!inputFile.existsSync()) throw 'File not found';
    var key = utf8.encode('p@ssw0rd');
    final bytes = await inputFile.readAsBytes();

    var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);

    print('DIGEST ${digest.toString()} and bytes ${digest.bytes}');

    final outputPath = inputPath.replaceFirst('.ts', '_encrypted.ts');
  }

  decrypt() {}
}
