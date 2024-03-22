import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naskrypt/controller/build_context_extension.dart';
import 'package:naskrypt/controller/date_context.dart';
import 'package:naskrypt/controller/video_service.dart';
import 'package:naskrypt/view/page/movie/movie_home.dart';

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
            SizedBox(height: 50.h),
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
                      crossAxisSpacing: 16.h,
                      mainAxisSpacing: 32.0.w,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      final content = contents[index];
                      return FutureBuilder<MovieInfo>(
                        future:
                            VideoService().getMovieContentInfo(content.path),
                        builder: (context, snapshot) {
                          final movieInfo = snapshot.data;

                          return InkWell(
                            borderRadius: BorderRadius.circular(10.r),
                            onTap: () async {
                              // await VideoService()
                              //     .decryptContents('${content.path}/content');
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.sp),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: Colors.black.withOpacity(0.8),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton.filledTonal(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.more_horiz,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: Image.file(
                                      File('${content.path}/thumbnail.jpg'),
                                      fit: BoxFit.cover,
                                      height: 220.h,
                                      width: 1.sw,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    movieInfo?.title ?? '',
                                    style: TextStyle(
                                      fontSize: 25.sp,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    movieInfo?.releaseDate.toYearString ?? '',
                                  ),
                                  SizedBox(height: 10.h),
                                  Text('${movieInfo?.director ?? ''}'
                                      ' | ${movieInfo?.producer ?? ''}'),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Divider(thickness: 0.5.sp),
                                  ),
                                  Text(
                                    movieInfo?.productionCompany ?? '',
                                    maxLines: 1,
                                  ),
                                  SizedBox(height: 16.h),
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
        ),
      ),
    );
  }
}
