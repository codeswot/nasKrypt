import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

abstract class CloudStorageService {
  Future<void> uploadFolderContents(Directory contentDirectory);
  void dispose();
}

class FirebaseCloudStorage implements CloudStorageService {
  final int maxRetries = 3;
  final Duration timeoutDuration = const Duration(seconds: 60);

  final StreamController<String> _uploadQueueController = StreamController<String>();
  Stream<String> get uploadQueue => _uploadQueueController.stream;

  FirebaseCloudStorage() {
    _initializeUploadQueueListener();
  }

  void _initializeUploadQueueListener() {
    uploadQueue.listen((filePath) async {
      try {
        await _processUpload(filePath);
      } catch (e) {
        if (kDebugMode) {
          print("Error processing upload for $filePath: $e");
        }
      }
    });
  }

// called by the queue listener when a file is added to the queue
  Future<void> _processUpload(String filePath) async {
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        await _uploadFileWithRetry(filePath);
        return;
      } catch (e) {
        if (kDebugMode) {
          print("Error uploading file $filePath: $e");
        }
        retryCount++;
        if (retryCount < maxRetries) {
          if (kDebugMode) {
            print("Retrying upload for $filePath (Attempt $retryCount of $maxRetries)");
          }
        } else {
          if (kDebugMode) {
            print("Failed to upload $filePath after $maxRetries attempts");
          }
          // Handle failure scenario, e.g., log, notify, etc.
        }
      }
    }
  }

  Future<void> _uploadFileWithRetry(String filePath) async {
    final directoryPath = filePath.substring(0, filePath.lastIndexOf('/'));
    final folderName = directoryPath.split('/').last;
    final fileName = filePath.split('/').last;

    final firebasePath = 'contents/$folderName/$fileName';

    if (kDebugMode) {
      print("Uploading $filePath to $firebasePath");
    }

    final file = File(filePath);
    if (kDebugMode) {
      print("File size: ${await file.length()} bytes");
    }

    final uploadTask = FirebaseStorage.instance.ref().child(firebasePath).putFile(file);

    await uploadTask.timeout(timeoutDuration, onTimeout: () {
      if (kDebugMode) {
        print('Upload timed out for $filePath');
      }
      throw TimeoutException('Upload timed out for $filePath');
    });

    if (kDebugMode) {
      print("Successfully uploaded $filePath to $firebasePath");
    }
    uploadTask.whenComplete(() {
      if (kDebugMode) {
        print('Upload completed for $filePath');
      }
    });
  }

  @override
  // adds content to queue for upload
  Future<void> uploadFolderContents(Directory contentDirectory) async {
    final List<FileSystemEntity> entities = contentDirectory.listSync(recursive: false);

    for (FileSystemEntity entity in entities) {
      if (entity is File) {
        _uploadQueueController.add(entity.path);
      }
    }
  }

  @override
  void dispose() {
    _uploadQueueController.close();
  }
}

CloudStorageService get cloudStorageServiceFirebase => FirebaseCloudStorage();
