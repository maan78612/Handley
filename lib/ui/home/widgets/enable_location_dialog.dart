import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/styles.dart';

Future<void> enableLocationDialog() async {
  Get.defaultDialog(
      title: '',
      backgroundColor: AppConfig.colors.whiteColor,
      titleStyle: latoBold.copyWith(fontSize: 12.sp),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: Get.height * 0.032,
            backgroundColor: AppConfig.colors.red,
            child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: Get.height * 0.030,
                child: Icon(
                  Icons.warning,
                  color: AppConfig.colors.red,
                  size: Get.height * 0.042,
                )),
          ),
          SizedBox(
            height: Get.height * 0.016,
          ),
          Text(
            "Please enable location to preceed",
            textAlign: TextAlign.center,
            style: latoRegular.copyWith(fontSize: 14.sp),
          ),
          SizedBox(height: Get.height * 0.02),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () async {
            Get.back();
            await Geolocator.openLocationSettings();

          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 16),
            width: Get.width * .3,
            height: Get.height * .05,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppConfig.colors.themeColor),
            child: Center(
              child: Text(
                'enable location',
                textAlign: TextAlign.center,
                style: latoBold.copyWith(
                    fontSize: 12.sp, color: AppConfig.colors.whiteColor),
              ),
            ),
          ),
        ),
      ]);
}