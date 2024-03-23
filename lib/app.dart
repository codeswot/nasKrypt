import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naskrypt/controller/video_service.dart';
import 'package:naskrypt/view/page/home.dart';

class NasKryptApp extends StatefulWidget {
  const NasKryptApp({super.key});

  @override
  State<NasKryptApp> createState() => _NasKryptAppState();
}

class _NasKryptAppState extends State<NasKryptApp> {
  @override
  void initState() {
    prep();
    super.initState();
  }

  prep() async {
    await VideoService().prepareWorkDirectory();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return MaterialApp(
          title: 'NasKrypt',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          home: const AppHome(),
        );
      },
    );
  }
}
