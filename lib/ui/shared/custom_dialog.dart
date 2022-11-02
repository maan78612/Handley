import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/ui/shared/app_button.dart';

class CustomDialog {
  static Future<bool> showConfirmationDialog(
      BuildContext context, String title) async {
    return await showDialog(
      context: context,
      builder: (context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text(title),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text("No"),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text("Yes"),
                onPressed: () => Navigator.of(context).pop(true),
              )
            ],
          );
        } else {
          return Container(
            constraints: const BoxConstraints(maxHeight: 300.0),
            child: AlertDialog(
              title: Text(title),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  static Future<bool> showEnableDisableDialog(
      BuildContext context, DateTime date) async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.sp))),
              content: Container(
                  height: 160.h,
                  width: 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back(result: false);
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Icon(Icons.cancel_outlined,
                              size: 20.sp,
                              color: AppConfig.colors.secondaryThemeColor),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppConfig.images.warningIcon,
                            fit: BoxFit.cover,
                            width: 67.sp,
                            height: 67.sp,
                          ),
                          SizedBox(width: 15.sp),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Are you sure you want to disable selected date?",
                                  style: latoBold.copyWith(
                                      fontSize: 14.sp,
                                      color:
                                          AppConfig.colors.secondaryThemeColor),
                                ),
                                SizedBox(height: 5.sp),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "SELECTED DATE",
                                      style: latoRegular.copyWith(
                                          fontSize: 10.sp,
                                          color: AppConfig
                                              .colors.secondaryThemeColor),
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      DateFormat.yMd().format(date),
                                      style: latoBold.copyWith(
                                          fontSize: 10.sp,
                                          color: AppConfig.colors.themeColor),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Expanded(
                              child: dialogBtn(
                            title: "Cancel",
                            textColor: AppConfig.colors.secondaryThemeColor,
                            isIcon: false,
                            btnColor: AppConfig.colors.whiteColor,
                            onTab: () {
                              Get.back(result: false);
                            },
                            borderColor: AppConfig.colors.secondaryThemeColor,
                          )),
                          SizedBox(width: 15.sp),
                          Expanded(
                              child: dialogBtn(
                                  title: "Confirm",
                                  textColor: AppConfig.colors.whiteColor,
                                  isIcon: false,
                                  btnColor: AppConfig.colors.themeColor,
                                  onTab: () {
                                    Get.back(result: true);
                                  },
                                  borderColor: AppConfig.colors.themeColor)),
                        ],
                      ),
                      Spacer(),
                    ],
                  )),
            ));
  }


  static Future startNewChatDialog(
      BuildContext context, Widget content())  {
    return  showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.sp))),
              content: content() ,
            ));
  }




  static Widget dialogBtn(
      {required String title,
      required Color textColor,
      required bool isIcon,
      required Color btnColor,
      required Color borderColor,
      required Function() onTab}) {
    return GestureDetector(
      onTap: onTab,
      child: Center(
        child: Container(
          height: 38.h,
          decoration: BoxDecoration(
              color: btnColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(10.sp)),
          child: Center(
            child: Text(
              title,
              style: latoBold.copyWith(fontSize: 12.sp, color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
