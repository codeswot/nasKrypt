import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
            Flexible(
              child: FutureBuilder<List<Directory>>(
                future: VideoService().getFoldersInOutputDirectory(),
                builder: (context, snapshot) {
                  final contents = snapshot.data ?? [];
                  if (contents.isEmpty) {
                    return const Center(
                      child: Text('No Content Proccessed'),
                    );
                  }
                  return GridView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 32.w,
                      mainAxisSpacing: 16.0.h,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      final content = contents[index];
                      return InkWell(
                        onTap: () async {
                          await VideoService()
                              .decryptContents('${content.path}/content');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: Colors.black.withOpacity(0.8),
                          ),
                          child: Column(
                            children: [
                              Image.file(File('${content.path}/thumbnail.jpg')),
                              SizedBox(height: 16.h),
                              Text(
                                content.path.split('/').last,
                                style: TextStyle(
                                  fontSize: 25.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
