import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naskrypt/controller/extensions.dart';

class MovieFileCard extends StatelessWidget {
  const MovieFileCard({
    super.key,
    required this.filePath,
  });

  final String filePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 450.w,
        minWidth: 360.w,
      ),
      padding: EdgeInsets.symmetric(vertical: 25.w, horizontal: 16.w),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: const Color(0xFF3A4B5D),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2.w, color: Colors.white),
          borderRadius: BorderRadius.circular(8.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C101828),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(),
            child: Icon(
              Icons.file_open,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            filePath.toVisualFileName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
              height: 0.07,
            ),
          ),
        ],
      ),
    );
  }
}
