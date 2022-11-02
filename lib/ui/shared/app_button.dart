import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_constants.dart';
import '../../utilities/dimension.dart';
import '../../constants/styles.dart';

Widget appButton(
    {required String title,
    required Color textColor,
    required bool isIcon,
      required btnColor,
    required Function() onTab}) {
  return GestureDetector(
    onTap: onTab,
    child: Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSmallSize),
        width: 342.w,
        height: 53.h,
        decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Expanded(
              flex: 4,
              child: Center(
                child: Text(
                  title,
                  style: latoBold.copyWith(
                      fontSize:18.sp, color: textColor),
                ),
              ),
            ),

            if (isIcon)
              Expanded(
                flex: 1,
                child: Image.asset(
                  AppConfig.images.forwardIcon,
                  scale: 5.h,
                ),
              ),
            // const Spacer( flex: 1),
          ],
        ),
      ),
    ),
  );
}
