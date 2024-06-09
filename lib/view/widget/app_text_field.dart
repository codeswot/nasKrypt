import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppContentDetailTextField extends StatelessWidget {
  const AppContentDetailTextField({
    super.key,
    required this.controller,
    required this.title,
    required this.hint,
    this.onChanged,
    this.onValidate,
  });
  final TextEditingController controller;
  final String title;
  final String hint;
  final Function(String? value)? onChanged;
  final String? Function(String?)? onValidate;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w500,
            height: 0.10,
          ),
        ),
        SizedBox(height: 16.w),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            fillColor: const Color(0xFF3A4B5D),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          validator: onValidate,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
