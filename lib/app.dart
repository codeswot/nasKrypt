import 'package:filesystem_picker/filesystem_picker.dart';
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
      designSize: const Size(1440, 960),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return FilesystemPickerDefaultOptions(
          fileTileSelectMode: FileTileSelectMode.wholeTile,
          theme: FilesystemPickerTheme(
            topBar: FilesystemPickerTopBarThemeData(
              backgroundColor: Colors.teal,
            ),
          ),
          child: MaterialApp(
            title: 'NasKrypt',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xff000710),
                brightness: Brightness.dark,
              ),
              scaffoldBackgroundColor: const Color(0xff000710),
              useMaterial3: true,
            ),
            home: const AppHome(),
          ),
        );
        
      },
    );
  }
}
