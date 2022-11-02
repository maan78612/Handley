import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_pro/constants/styles.dart';

class EmptyScreen extends StatelessWidget {
  String image;
  String message;
  bool isAddAppBarSize;

  EmptyScreen(
      {Key? key,
      required this.image,
      required this.message,
      this.isAddAppBarSize = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          image,
          height: 75.h,
          width: 75.w,
          color: Color(0xffD9D4D5),
        ),
        SizedBox(height: 5.h),
        Text(
          message,
          style: latoBold.copyWith(fontSize: 12.sp, color: Color(0xffD9D4D5)),
        ),
        /* To cover app bar height */
        if (isAddAppBarSize) SizedBox(height: 120.h)
      ],
    );
  }
}
