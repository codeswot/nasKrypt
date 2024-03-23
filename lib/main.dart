// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naskrypt/app.dart';

Future<void> main() async {
  // Enable content compression
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: NasKryptApp(),
    ),
  );
}
