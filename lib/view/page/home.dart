import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naskrypt/controller/build_context_extension.dart';

import 'package:naskrypt/view/page/movie/pick_movie_file.dart';

class AppHome extends ConsumerStatefulWidget {
  const AppHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppHomeState();
}

class _AppHomeState extends ConsumerState<AppHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
 
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.w),
              child: Text(
                'COPYRIGHT © NASBOX ${DateTime.now().year}. ALL RIGHTS RESERVED',
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 82.w),
              Image.asset(
                'assets/images/logo.png',
                width: 176.w,
                height: 32.w,
              ),
              SizedBox(height: 107.w),
              Text(
                'What type content would you like to encrypt?',
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 43.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CardOption(
                    title: 'Movies',
                    description: 'Select and encrypt a movie',
                    icon: 'assets/images/movie.png',
                    onTap: () => context.pushRoute(const PickMovieFileScreen()),
                  ),
                  SizedBox(width: 31.w),
                  CardOption(
                    title: 'TV Shows',
                    icon: 'assets/images/tv.png',
                    description: 'Select and encrypt a TV shows',
                    onTap: () {},
                  ),
                ],
              ),
              // SizedBox(height: 32.h),
              // ElevatedButton.icon(
              //   onPressed: () => context.pushRoute(const DecryptScreen()),
              //   icon: const Icon(Icons.no_encryption),
              //   label: const Text('Processed Contents'),
              // )
            ],
          ),
        ],
      ),
    );
  }
}

class CardOption extends StatelessWidget {
  const CardOption({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.onTap,
  });
  final String title;
  final String description;
  final String icon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.68.r),
      onTap: onTap,
      child: Container(
        width: 449.w,
        height: 271.h,
        padding: EdgeInsets.all(5.sp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.68.r),
          border: Border.all(
            width: 2.sp,
            strokeAlign: BorderSide.strokeAlignInside,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
        child: Stack(
          children: [
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Radio.adaptive(
            //     value: false,
            //     groupValue: true,
            //     onChanged: (v) {},
            //   ),
            // ),
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        icon,
                        width: 48.w,
                        height: 48.w,
                      ),
                      SizedBox(height: 16.w),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.w),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
