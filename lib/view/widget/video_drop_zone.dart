import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class VideoDropZone extends HookConsumerWidget {
  const VideoDropZone({this.onFileDropped, super.key});
  final Function(DropDoneDetails)? onFileDropped;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dragging = useState(false);

    final list = useState(<XFile>[]);

    return DropTarget(
      enable: true,
      onDragDone: (detail) async {
        list.value.addAll(detail.files);
        onFileDropped?.call(detail);
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
        width: 1.sw,
        decoration: BoxDecoration(
          color: dragging.value
              ? Colors.blue.withOpacity(0.4)
              : Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: list.value.isEmpty
            ? const Center(child: Text("Drop Movie here"))
            : Icon(
                Icons.movie,
                size: 100.sp,
              ),
      ),
    );
  }
}
