import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naskrypt/video_service.dart';

class VideoDropZone extends HookConsumerWidget {
  const VideoDropZone({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dragging = useState(false);

    final list = useState(<XFile>[]);

    return DropTarget(
      enable: true,
      onDragDone: (detail) async {
        list.value.addAll(detail.files);

        await VideoService().startProcess(detail.files.first.path);
      },
      onDragEntered: (detail) {
        dragging.value = true;
      },
      onDragExited: (detail) {
        dragging.value = false;
      },
      child: Container(
        margin: EdgeInsets.all(32.sp),
        padding: EdgeInsets.all(32.sp),
        height: 1.sh * 0.9.h,
        width: 1.sw,
        decoration: BoxDecoration(
          color: dragging.value ? Colors.blue.withOpacity(0.4) : Colors.black26,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: list.value.isEmpty
            ? const Center(child: Text("Drop here"))
            : Text(list.value.first.path),
      ),
    );
  }
}
