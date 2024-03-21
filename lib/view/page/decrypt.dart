import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naskrypt/controller/build_context_extension.dart';
import 'package:naskrypt/controller/video_service.dart';

class DecryptScreen extends ConsumerStatefulWidget {
  const DecryptScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DecryptScreenState();
}

class _DecryptScreenState extends ConsumerState<DecryptScreen> {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton.filledTonal(
              onPressed: () => context.popRoute(),
              icon: const Icon(
                Icons.chevron_left,
              ),
            ),
            SizedBox(height: 90.h),
            ElevatedButton(
              onPressed: () async {
                String? result = await FilePicker.platform.getDirectoryPath();
                if (result == null) return;
                if (kDebugMode) {
                  print('folder path is $result');
                }
                await VideoService().decryptContents(result);
              },
              child: const Text('Pick Content Folder'),
            )
          ],
        ),
      ),
    );
  }
}
