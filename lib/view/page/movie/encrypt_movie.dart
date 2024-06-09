import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:naskrypt/controller/build_context_extension.dart';
import 'package:naskrypt/controller/extensions.dart';
import 'package:naskrypt/controller/video_service.dart';
import 'package:naskrypt/model/content_info.dart';
import 'package:naskrypt/view/page/home.dart';
import 'package:naskrypt/view/widget/app_back_button.dart';
import 'package:naskrypt/view/widget/movie_file_card.dart';

class EncryptMovieScreen extends StatefulHookConsumerWidget {
  const EncryptMovieScreen({required this.contentInfo, super.key});
  final ContentInfo contentInfo;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EncryptMovieScreenState();
}

class _EncryptMovieScreenState extends ConsumerState<EncryptMovieScreen> {
  @override
  void initState() {
    _startEncryption();
    super.initState();
  }

  _startEncryption() async {
    if (widget.contentInfo.contentPath != null) {
      try {
        await VideoService().startProcess(widget.contentInfo);
        // Get.showSnackbar(GetSnackBar(
        //   title: 'Encrypted ${widget.contentInfo.title}',
        //   message: 'Check the encrypted content List',
        //   snackPosition: SnackPosition.TOP,
        //   padding: EdgeInsets.only(left: 1.sw / 3, right: 32.w),
        // ));
        if (mounted) {
          context.pushReplacementRoute(const AppHome());
        }
      } catch (e) {
        rethrow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomAppBar(
            showBack: false,
          ),
          SizedBox(height: 77.w),
          MovieFileCard(filePath: widget.contentInfo.contentPath ?? widget.contentInfo.title),
          SizedBox(height: 57.w),
          Text(
            'Encrypting ${widget.contentInfo.type.name.toSentenceCase()}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 0.05,
            ),
          ),
          SizedBox(height: 32.w),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.sw / 3),
            child: SizedBox(
              height: 16.w,
              child: const LinearProgressIndicator(
                backgroundColor: Color(0xFF3A4B5D),
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
