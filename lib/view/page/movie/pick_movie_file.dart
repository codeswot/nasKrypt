import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naskrypt/controller/build_context_extension.dart';
import 'package:naskrypt/view/page/movie/set_movie_details.dart';
import 'package:naskrypt/view/widget/app_back_button.dart';
import 'package:naskrypt/view/widget/video_drop_zone.dart';

class PickMovieFileScreen extends StatefulWidget {
  const PickMovieFileScreen({super.key});

  @override
  State<PickMovieFileScreen> createState() => _PickMovieFileScreenState();
}

class _PickMovieFileScreenState extends State<PickMovieFileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomAppBar(),
          SizedBox(height: 107.w),
          Text(
            "What type content would you like to encrypt",
            style: TextStyle(
              fontSize: 36.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 37.w),
          InkWell(
            borderRadius: BorderRadius.circular(8.r),
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.video,
              );
              _setupFilePath(result?.files.first.path);
            },
            child: Container(
              width: 360.w,
              clipBehavior: Clip.antiAlias,
              padding: EdgeInsets.symmetric(vertical: 32.w, horizontal: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: Colors.white,
                  width: 2.sp,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0C101828),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.file_open,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Pick a file from system',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Satoshi',
                      height: 0.07,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 41.w),
          Text(
            'OR',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
              height: 0.04,
            ),
          ),
          SizedBox(height: 41.w),
          VideoDropZone(
            onFileDropped: (movieFilePath) => _setupFilePath(movieFilePath),
          )
        ],
      ),
    );
  }

  _setupFilePath(String? filePath) {
    if (filePath != null) {
      context.pushRoute(SetMovieDetails(filePath));
    }
  }
}
