import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/UI/Chat/chat.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/services/auth_services.dart';
import 'package:social_pro/ui/auth/sign_in_view.dart';
import 'package:social_pro/ui/more/profile/edit_profile.dart';
import 'package:social_pro/ui/more/saved_addresses/saved_addresses.dart';
import 'package:social_pro/utilities/enums.dart';


class More extends StatelessWidget {
  const More({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppConfig.colors.whiteColor,
        body: Container(
          padding: EdgeInsets.all(8.0.sp),
          margin: EdgeInsets.symmetric(horizontal: 10.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Account",
                style: latoBlack.copyWith(
                    fontSize: 16.sp,
                    color: AppConfig.colors.secondaryThemeColor),
              ),
              accountOptionCard(
                title: 'YOUR PROFILE',
                image: AppConfig.images.account,
                onTab: () {
                  Get.to(EditProfile());
                },
              ),
              if (AppUser.user.userType == UserType.customer)
                accountOptionCard(
                  title: 'SAVED ADDRESSES',
                  image: AppConfig.images.location,
                  onTab: () {
                    Get.to(SavedAddresses());
                  },
                ),
              Text(
                "Other",
                style: latoBlack.copyWith(
                    fontSize: 16.sp,
                    color: AppConfig.colors.secondaryThemeColor),
              ),
              accountOptionCard(
                title: 'HELP',
                image: AppConfig.images.help,
                onTab: () {},
              ),
              accountOptionCard(
                title: 'ABOUT HANDLEY',
                image: AppConfig.images.about,
                onTab: () {},
              ),
              accountOptionCard(
                title: 'TERMS AND CONDITIONS',
                image: AppConfig.images.termsAndCon,
                onTab: () {},
              ),
              accountOptionCard(
                title: 'PRIVACY POLICIES',
                image: AppConfig.images.privacyPolicy,
                onTab: () {},
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(8.0.sp),
          margin: EdgeInsets.symmetric(horizontal: 10.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [chatButton(authProvider), _signOutButton(authProvider)],
          ),
        ),
      );
    });
  }

  Widget _signOutButton(AuthProvider auth) {
    return GestureDetector(
      onTap: () {
        Get.back();
        Get.bottomSheet(_areYouSureToLogOutBottom(auth));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        width: Get.width,
        decoration: BoxDecoration(
            border: Border.all(color: AppConfig.colors.themeColor),
            color: Color(0xffFDEEED),
            borderRadius: BorderRadius.circular(10.sp)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                AppConfig.images.signOutIcon,
                width: 18.w,
                height: 18.h,
              ),
              SizedBox(
                width: 10.w,
              ),
              Text("LOGOUT",
                  style: latoBold.copyWith(
                      fontSize: 12.sp, color: AppConfig.colors.red))
            ],
          ),
        ),
      ),
    );
  }

  Widget chatButton(AuthProvider auth) {
    return GestureDetector(
      onTap: () {
        Get.to(CustomChat());
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        width: Get.width,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            color: AppConfig.colors.themeColor,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                AppConfig.images.chat,
                width: 18.w,
                height: 18.h,
                color: AppConfig.colors.whiteColor,
              ),
              SizedBox(
                width: 10.w,
              ),
              Text("YOUR CHATS",
                  style: latoBold.copyWith(
                      fontSize: 12.sp, color: AppConfig.colors.whiteColor))
            ],
          ),
        ),
      ),
    );
  }

  Widget _areYouSureToLogOutBottom(AuthProvider auth) {
    return Container(
        decoration: BoxDecoration(
            color: AppConfig.colors.whiteColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(26), topRight: Radius.circular(26))),

        padding: EdgeInsets.symmetric(
            horizontal: Get.width * .05, vertical: Get.height * .02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 75.h,
              width: 75.h,
              child: Image.asset(
                AppConfig.images.alertIcon,
              ),
            ),
            SizedBox(height: 20.h),
            Text("Are you sure you want to logout?",
                style: latoRegular.copyWith(
                    fontSize: 14.sp,
                    color: AppConfig.colors.secondaryThemeColor)),
            SizedBox(
              height: Get.height * .02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                yesNoButton(
                  title: 'CANCEL',
                  borderColor: AppConfig.colors.secondaryThemeColor,
                  bgColor: AppConfig.colors.whiteColor,
                  onTab: () {
                    Get.back();
                  },
                  textColor: AppConfig.colors.secondaryThemeColor,
                ),
                SizedBox(
                  width: Get.width * .03,
                ),
                yesNoButton(
                  title: 'LOGOUT',
                  borderColor: AppConfig.colors.themeColor,
                  bgColor: Color(0xffFDEEED),
                  onTab: () async {
                    await AuthServices.signOut();
                    Get.offAll(() => (SignInView()));
                  },
                  textColor: AppConfig.colors.themeColor,
                ),
              ],
            ),
            SizedBox(height: 30.h),
          ],
        ));
  }

  Widget yesNoButton(
      {required String title,
      required Color bgColor,
      required Color textColor,
      required Color borderColor,
      required Function onTab}) {
    return GestureDetector(
      onTap: () async {
        onTab();
      },
      child: Container(
        height: 40.h,
        width: 150.w,
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12.sp),
            border: Border.all(color: borderColor)),
        child: Center(
            child: Text(title,
                style:
                    latoRegular.copyWith(fontSize: 12.sp, color: textColor))),
      ),
    );
  }

  Widget accountOptionCard(
      {required String title, required String image, required Function onTab}) {
    return GestureDetector(
      onTap: () {
        onTab();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 6.w),
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 6.w),
        width: Get.width,
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xffD9D4D5)),
            color: Color(0xffF5F4F4),
            borderRadius: BorderRadius.circular(10.sp)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 10.w),
            Image.asset(
              image,
              width: 15.w,
              height: 15.h,
              color: AppConfig.colors.secondaryThemeColor,
            ),
            SizedBox(width: 10.w),
            Text(title,
                style: latoBold.copyWith(
                    fontSize: 12.sp,
                    color: AppConfig.colors.secondaryThemeColor))
          ],
        ),
      ),
    );
  }
}
