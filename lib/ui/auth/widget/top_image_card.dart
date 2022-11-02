import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/authentication_provider.dart';


class TopImageCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, auth, _) {
      return _topAddImageCard(auth);
    });
  }

  Widget _topAddImageCard(AuthProvider auth) {
    double imageRadius = 28.sp;
    return GestureDetector(
      onTap: () {
        auth.getUserImageFunc();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: imageRadius),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
                padding: EdgeInsets.all(4.sp),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.sp),
                    border: Border.all(color: AppConfig.colors.themeColor)),
                child: auth.userImage != null
                    ? Image.file(
                        auth.userImage!,
                        fit: BoxFit.contain,
                        width: 90.w,
                        height: 90.h,
                      )
                    : AppUser.user.imageUrl != ""
                        ? CachedNetworkImage(
                            imageUrl: AppUser.user.imageUrl,
                            fit: BoxFit.contain,
                            width: 90.w,
                            height: 90.h,
                          )
                        : Padding(
                          padding:  EdgeInsets.all(20.0.sp),
                          child: Image.asset(
                              AppConfig.images.account,
                              color: AppConfig.colors.themeColor,
                              fit: BoxFit.contain,
                              width: 50.w,
                              height: 50.h,
                            ),
                        )),
            Positioned(
              top: -imageRadius / 3,
              right: -imageRadius / 3,
              child: Container(
                width: imageRadius.sp,
                height: imageRadius.sp,
                padding: EdgeInsets.all(imageRadius / 5),
                decoration: BoxDecoration(
                  color: AppConfig.colors.themeColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  AppConfig.images.startNewChat,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
