import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mime/mime.dart';

class VideoDropZone extends HookConsumerWidget {
  const VideoDropZone({this.onFileDropped, super.key});
  final Function(String)? onFileDropped;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dragging = useState(false);
    final showError = useState(false);
    final errorMessage = useState('');

    return DropTarget(
      enable: true,
      onDragDone: (detail) async {
        if (detail.files.length > 1) {
          showError.value = true;
          errorMessage.value = 'You can only drop one file at a time';
          return;
        }
        final movieFile = detail.files.first;

        final mimeType = lookupMimeType(movieFile.path);

        if (mimeType?.contains('video/') == false) {
          showError.value = true;
          errorMessage.value = 'Only video files are supported';
          return;
        }

        onFileDropped?.call(movieFile.path);
        errorMessage.value = '';
        showError.value = false;
      },
      onDragEntered: (detail) {
        dragging.value = true;
      },
      onDragExited: (detail) {
        dragging.value = false;
      },
      child: DottedBorder(
        color: Colors.white,
        strokeWidth: 2.w,
        dashPattern: [8.w, 8.w],
        radius: Radius.circular(20.68.r),
        borderType: BorderType.RRect,
        child: Container(
          width: 855.w,
          height: 271.w,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.68.r),
            color: showError.value
                ? const Color(0xffFFB4AA).withOpacity(0.3)
                : dragging.value
                    ? const Color(0xFF3A4B5D).withOpacity(0.1)
                    : const Color(0xFF3A4B5D),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Drag and drop a movie here',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                showError.value ? errorMessage.value : 'Drop and encrypt a movie',
                style: TextStyle(
                  fontSize: 24.sp,
                  color: showError.value ? const Color(0xffFFB4AA) : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
