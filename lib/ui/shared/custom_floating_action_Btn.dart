import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/UI/Chat/chat.dart';
import 'package:social_pro/provider/chat_provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';


class CustomFloatingActionBtn {
  static Widget customFloatingActionButton(BuildContext context) {
    return StreamBuilder(
        stream: Provider.of<ChatProvider>(context, listen: false)
            .allUnreadMessages(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
          if (!snap.hasData) {
            return SizedBox.shrink();
          } else {
            int count = snap.data!.docs.length;
            return count > 0
                ? InkWell(
                    onTap: () {
                      Get.to(CustomChat());
                    },
                    child: Container(
                      padding: EdgeInsets.all(14.sp),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppConfig.colors.themeColor, width: 1),
                        color: AppConfig.colors.whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppConfig.colors.themeColor,
                            blurRadius: 10.sp,
                            offset: Offset(0.sp, 5.sp),
                          )
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: Badge(
                        badgeContent: Text(
                          count < 1 ? "" : count.toString(),
                          style: latoBold.copyWith(
                              color: AppConfig.colors.whiteColor,
                              fontSize: 12.sp),
                        ),
                        position: BadgePosition(top: -25.sp, end: -17.sp),
                        padding: EdgeInsets.all(8.sp),
                        shape: BadgeShape.circle,
                        badgeColor: AppConfig.colors.red,
                        child: Image.asset(AppConfig.images.chat,
                            width: 25.w,
                            height: 25.h,
                            color: AppConfig.colors.themeColor),
                      ),
                    ),
                  )
                : SizedBox.shrink();
          }
        });
  }
}
