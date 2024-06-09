import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naskrypt/controller/build_context_extension.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    this.showBack = true,
    super.key,
  });
  final bool showBack;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 72.w, top: 82.w),
      child: Stack(
        children: [
          if (showBack)
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () => context.popRoute(),
                child: Container(
                  width: 137.w,
                  padding: EdgeInsets.symmetric(vertical: 20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      SizedBox(width: 20.w),
                      const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/logo.png',
              width: 176.w,
              height: 32.w,
            ),
          ),
        ],
      ),
    );
  }
}
