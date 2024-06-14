import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naskrypt/controller/build_context_extension.dart';
import 'package:naskrypt/controller/cloud_storage_service.dart';
import 'package:naskrypt/controller/extensions.dart';
import 'package:naskrypt/controller/video_service.dart';
import 'package:naskrypt/model/content_info.dart';
import 'package:naskrypt/view/widget/app_back_button.dart';

class DecryptScreen extends ConsumerStatefulWidget {
  const DecryptScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DecryptScreenState();
}

class _DecryptScreenState extends ConsumerState<DecryptScreen> {
  final TextEditingController searchController = TextEditingController();
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomAppBar(),
        SizedBox(height: 40.w),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 48.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Encrypted contents',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36.sp,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                width: 313.w,
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search movie',
                    prefixIcon: const Icon(Icons.search),
                    fillColor: const Color(0xFF3A4B5D),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onChanged: (c) {},
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 47.w),
        Flexible(
          child: StreamBuilder<List<Directory>>(
            stream: VideoService().getFoldersInOutputDirectory$(),
            builder: (context, snapshot) {
              final contents = snapshot.data ?? [];

              if (contents.isEmpty) {
                return const Center(
                  child: Text('No Content Proccessed'),
                );
              }
              return GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 48.w),
                itemCount: snapshot.data?.length ?? 0,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 27.w,
                  mainAxisSpacing: 27.0.w,
                  mainAxisExtent: 350.w,
                ),
                itemBuilder: (context, index) {
                  final content = contents[index];
                  print("con ${content.path}/thumbnail.jpg");
                  return FutureBuilder<ContentInfo>(
                    future: VideoService().getMovieContentInfo(content.path),
                    builder: (context, snapshot) {
                      final movieInfo = snapshot.data;

                      return InkWell(
                        borderRadius: BorderRadius.circular(10.r),
                        onTap: () async {
                          // await VideoService()
                          //     .decryptContents('${content.path}/content');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.82.r),
                            color: const Color(0xFF3A4B5D),
                            border: Border.all(
                              color: Colors.white,
                              width: 1.95.sp,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(7.82.r),
                                  topRight: Radius.circular(7.82.r),
                                ),
                                child: Image.file(
                                  File('${content.path}/thumbnail.jpg'),
                                  fit: BoxFit.cover,
                                  height: 189.w,
                                  width: 1.sw,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Text('$error'),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 11.w),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 13.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          movieInfo?.title ?? '',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.sp,
                                            fontFamily: 'Satoshi',
                                            fontWeight: FontWeight.w500,
                                            height: 0.07,
                                          ),
                                        ),
                                        PopupMenuButton<int>(
                                          icon: const Icon(Icons.more_vert),
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              onTap: () async {
                                                context.showAppDilog(
                                                  'Add to Sd card',
                                                  'Select Sd Card to add movie to',
                                                  [
                                                    TextButton(
                                                      onPressed: () {
                                                        context.popRoute();
                                                      },
                                                      child: const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        final String? directoryPath = await getDirectoryPath();
                                                        if (directoryPath == null) {
                                                          // Operation was canceled by the user.
                                                          return;
                                                        }
                                                        VideoService().zipFromTo(content, directoryPath);

                                                        if (context.mounted) {
                                                          context.popRoute();
                                                        }
                                                      },
                                                      child: const Text('Select'),
                                                    ),
                                                  ],
                                                );
                                              },
                                              value: 0,
                                              child: const Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Icon(Icons.sd_card),
                                                  Text('Send to SD Card'),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              onTap: () {
                                                context.showAppDilog(
                                                  'Upload to Server',
                                                  'This action will upload ${movieInfo?.title} to the NasBox Server',
                                                  [
                                                    TextButton(
                                                      onPressed: () {
                                                        context.popRoute();
                                                      },
                                                      child: const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        cloudStorageServiceFirebase.uploadFolderContents(content);

                                                        if (context.mounted) {
                                                          context.popRoute();
                                                        }
                                                      },
                                                      child: const Text('Upload'),
                                                    )
                                                  ],
                                                );
                                              },
                                              value: 1,
                                              child: const Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Icon(Icons.cloud),
                                                  Text('Upload to Server'),
                                                ],
                                              ),
                                            ),
                                            const PopupMenuDivider(),
                                            PopupMenuItem(
                                              onTap: () {
                                                context.showAppDilog(
                                                  'Delete Movie',
                                                  'Are you sure you want to delete ${movieInfo?.title} ?',
                                                  [
                                                    TextButton(
                                                      onPressed: () {
                                                        context.popRoute();
                                                      },
                                                      child: const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        await content.delete(recursive: true);
                                                        if (context.mounted) {
                                                          context.popRoute();
                                                        }
                                                        setState(() {});
                                                      },
                                                      child: const Text('Delete'),
                                                    ),
                                                  ],
                                                );
                                              },
                                              value: 2,
                                              child: const Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  Text('Delete this Movie'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 7.w),
                                    Text(
                                      '${movieInfo?.releaseDate.toYearString}  • ${movieInfo?.genres.first} • ${movieInfo?.runtimeInMilli.toHoursMinutes()}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontFamily: 'Satoshi',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    SizedBox(height: 11.w),
                                    Row(
                                      children: [
                                        KeyValuePairWidget(
                                          title: 'Director',
                                          value: movieInfo?.director ?? '',
                                        ),
                                        SizedBox(width: 22.w),
                                        KeyValuePairWidget(
                                          title: 'Producer',
                                          value: movieInfo?.producer ?? '',
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 24.w),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        )
      ],
    )

        //     ],
        //   ),
        // ),

        );
  }

  @override
  void dispose() {
    cloudStorageServiceFirebase.dispose();
    super.dispose();
  }
}

class KeyValuePairWidget extends StatelessWidget {
  const KeyValuePairWidget({
    super.key,
    required this.title,
    required this.value,
  });
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w400,
            // height: 0.09,
            // letterSpacing: 0.10,
          ),
        ),
        SizedBox(height: 1.29.w),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w400,
            // height: 0.09,
            // letterSpacing: 0.10,
          ),
        ),
      ],
    );
  }
}
