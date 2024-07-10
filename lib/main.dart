// import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naskrypt/app.dart';
import 'package:naskrypt/firebase_options.dart';

Future<void> main() async {
  // Enable content compression
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth.instance.signInAnonymously();

  runApp(
    const ProviderScope(
      child: NasKryptApp(),
    ),
  );
}
