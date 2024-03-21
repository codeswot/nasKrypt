// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naskrypt/app.dart';

void main() async {
  // Enable content compression

  runApp(
    const ProviderScope(
      child: NasKryptApp(),
    ),
  );
}
