import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PickerBackground extends StatelessWidget {
  const PickerBackground({
    required this.child,
    this.errorBorder = false,
    super.key,
  });
  final Widget child;
  final bool errorBorder;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3A4B5D),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          width: 2.w,
          color: errorBorder ? const Color(0xffFFB4AA) : Colors.white,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C101828),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: child,
    );
  }
}
