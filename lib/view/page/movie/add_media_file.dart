import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naskrypt/controller/build_context_extension.dart';
import 'package:naskrypt/controller/video_service.dart';
import 'package:naskrypt/view/page/movie/movie_home.dart';
import 'package:naskrypt/view/widget/video_drop_zone.dart';

class AddMovieMediaFile extends StatefulWidget {
  const AddMovieMediaFile(this.movieInfo, {super.key});
  final MovieInfo movieInfo;
  @override
  State<AddMovieMediaFile> createState() => _AddMovieMediaFileState();
}

class _AddMovieMediaFileState extends State<AddMovieMediaFile> {
  bool isProcessing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.sw,
        padding: EdgeInsets.all(32.sp),
        margin: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: isProcessing
            ? Center(
                child: Column(
                  children: [
                    const Text('Processing Video'),
                    SizedBox(height: 32.h),
                    const LinearProgressIndicator(),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton.filledTonal(
                    onPressed: () => context.popRoute(),
                    icon: const Icon(
                      Icons.chevron_left,
                    ),
                  ),
                  SizedBox(height: 90.h),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(
                                  allowMultiple: false,
                                  type: FileType.custom,
                                  allowedExtensions: [
                                'mp4',
                              ]);
                          List files = result?.files ?? [];
                          if (files.isEmpty) return;

                          setState(() {
                            isProcessing = true;
                          });
                          await VideoService()
                              .startProcess(files.first.path, widget.movieInfo);
                          setState(() {
                            isProcessing = false;
                          });
                        },
                        child: const Text('Pick File from System'),
                      ),
                      SizedBox(width: 16.w),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Pick File from web'),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.w),
                  Row(
                    children: [
                      const Flexible(child: Divider()),
                      SizedBox(width: 8.w),
                      const Text('OR'),
                      SizedBox(width: 8.w),
                      const Flexible(child: Divider()),
                    ],
                  ),
                  SizedBox(
                    height: 500.h,
                    child: VideoDropZone(
                      onFileDropped: (result) async {
                        List<XFile> files = result.files;
                        if (files.isEmpty) return;

                        setState(() {
                          isProcessing = true;
                        });
                        await VideoService()
                            .startProcess(files.first.path, widget.movieInfo);
                        setState(() {
                          isProcessing = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
