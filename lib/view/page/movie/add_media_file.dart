import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naskrypt/controller/build_context_extension.dart';
import 'package:naskrypt/controller/video_service.dart';
import 'package:naskrypt/model/content_info.dart';
import 'package:naskrypt/view/widget/video_drop_zone.dart';

class AddContentMediaFile extends StatefulWidget {
  const AddContentMediaFile(this.contentInfo, {super.key});
  final ContentInfo contentInfo;
  @override
  State<AddContentMediaFile> createState() => _AddContentMediaFileState();
}

class _AddContentMediaFileState extends State<AddContentMediaFile> {
  bool isProcessing = false;
  @override
  void initState() {
    super.initState();
  }

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
                              .pickFiles(allowMultiple: false, type: FileType.custom, allowedExtensions: [
                            'mp4',
                          ]);
                          List files = result?.files ?? [];
                          if (files.isEmpty) return;

                          setState(() {
                            isProcessing = true;
                          });
                          await VideoService().startProcess(files.first.path, widget.contentInfo);
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
                        await VideoService().startProcess(files.first.path, widget.contentInfo);
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


extension IntExtension on int {
  String toDurationString() {
    Duration duration = Duration(milliseconds: this);

    if (duration.inDays >= 30) {
      return '${duration.inDays ~/ 30} months';
    } else if (duration.inDays >= 7) {
      return '${duration.inDays ~/ 7} weeks';
    } else if (duration.inDays > 0) {
      return '${duration.inDays} days';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hours';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minutes';
    } else if (duration.inSeconds > 0) {
      return '${duration.inSeconds} seconds';
    } else {
      return '${duration.inMilliseconds} milliseconds';
    }
  }
}
