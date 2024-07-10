import 'package:cloud_firestore/cloud_firestore.dart';

abstract class RemoteDatabaseService {
  Future<void> setContent(Map<String, dynamic> content, String path);
  void dispose();
}

class FirebaseFirestoreRemoteDatabase implements RemoteDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> setContent(Map<String, dynamic> content, String path) async {
    await _firestore.collection('contents').doc().set({
      'storeagePath': 'contents/$path',
      ...content,
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}

RemoteDatabaseService get remoteDatabaseServiceFirebaseFirestore => FirebaseFirestoreRemoteDatabase();
