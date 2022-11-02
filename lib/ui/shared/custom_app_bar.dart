import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_constants.dart';
import '../../constants/styles.dart';





AppBar customAppBar({required Function onTab,  required String title}) {
  return AppBar(
    backgroundColor: AppConfig.colors.whiteColor,
    elevation: 0,
    centerTitle: true,
    leading: IconButton(
        onPressed: () {
          onTab();
        },
        icon: Icon(
          Icons.arrow_back,
          color: AppConfig.colors.secondaryThemeColor,
        )),
    title: Text(
      title,
      style: latoBlack.copyWith(
          fontSize: 16.sp, color: AppConfig.colors.secondaryThemeColor),
    ),
    actions: [
      Padding(
        padding: EdgeInsets.only(right: 10.sp),
        child: Image.asset(
          AppConfig.images.logoShort,
          height: 64.h,
        ),
      ),
    ],
  );
}