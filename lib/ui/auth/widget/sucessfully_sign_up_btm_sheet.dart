// successfully sign up bottom sheet

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/ui/dashoard/dashboard.dart';
import 'package:social_pro/utilities/dimension.dart';


class SuccessfullySignUpBottom extends StatefulWidget {
  @override
  _SuccessfullySignUpBottomState createState() =>
      _SuccessfullySignUpBottomState();
}

class _SuccessfullySignUpBottomState extends State<SuccessfullySignUpBottom> {
  @override
  void initState() {
    Timer(const Duration(seconds: 4), () {
      Provider.of<AuthProvider>(Get.context!, listen: false).clearSignUpData();
      Get.offAll(DashBoard(index: 0));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: AppConfig.colors.whiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.radiusDefault),
                topRight: Radius.circular(Dimensions.radiusDefault))),
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault,
            vertical: Dimensions.paddingSmallSize),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 100.h,
              width: 100.h,
              child: Image.asset(
                AppConfig.images.checkIcon,
                color: AppConfig.colors.themeColor,
              ),
            ),
            Text(
              "Congratulations",
              style: latoBold.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: AppConfig.colors.secondaryThemeColor,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              width: 400.w,
              child: Text(
                "Sign up has been successful.",
                textAlign: TextAlign.center,
                style: latoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: AppConfig.colors.secondaryThemeColor,
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
          ],
        ));
  }
}
