
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/UI/Notification/notification.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/ui/bookings/booking_details.dart';
import 'package:social_pro/utilities/enums.dart';


AppBar authAppBar({required Function onTab}) {
  return AppBar(
    backgroundColor: AppConfig.colors.whiteColor,
    elevation: 0,
    leading: IconButton(
        onPressed: () {
          onTab();
        },
        icon: Icon(
          Icons.arrow_back,
          color: AppConfig.colors.secondaryThemeColor,
        )),
    actions: [
      Padding(
        padding: EdgeInsets.only(right: 10.sp),
        child: Image.asset(
          AppConfig.images.logoShort,
          height: 95.h,
        ),
      ),
    ],
  );
}

PreferredSize dashboardAppBar(AppProvider appProvider) {
  return PreferredSize(
      preferredSize: Size.fromHeight(70.h),
      child: Column(
        children: [
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 20.w),
              Image.asset(AppConfig.images.logo,
                  fit: BoxFit.fitWidth, height: 60.h, width: 80.w),
              const Spacer(),
              if (AppUser.user.userType == UserType.professional)
                calendarBtn(appProvider),
              SizedBox(width: 10.w),
              notificationBtn(appProvider),
              SizedBox(width: 20.w),
            ],
          ),
        ],
      ));
}

Widget notificationBtn(AppProvider appProvider) {
  return GestureDetector(
    onTap: () {
      Get.to(AppNotifications());
    },
    child: Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: 37.h,
          height: 38.h,
          decoration: BoxDecoration(
            color: const Color(0xffF5F4F4),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(8.sp),
          child: Image.asset(
            AppConfig.images.notification,
            color: AppConfig.colors.themeColor,
            fit: BoxFit.contain,
            width: 16.w,
            height: 20.h,
          ),
        ),
        appProvider.isSeenNotification
            ? Container(
                width: 10.h,
                height: 10.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppConfig.colors.themeColor,
                ),
              )
            : SizedBox.shrink(),
      ],
    ),
  );
}

Widget calendarBtn(AppProvider appProvider) {
  return GestureDetector(
    onTap: () {
      Get.to(BookingDetails(
        professionalUser: AppUser.user,
        bookingList: appProvider.userActiveBookings,
      ));
    },
    child: Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: 37.h,
          height: 38.h,
          decoration: BoxDecoration(
            color: const Color(0xffF5F4F4),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(8.sp),
          child: Image.asset(
            AppConfig.images.calendar,
            color: AppConfig.colors.themeColor,
            fit: BoxFit.contain,
            width: 16.w,
            height: 20.h,
          ),
        ),
        appProvider.userActiveBookings.isNotEmpty
            ? Container(
                padding: EdgeInsets.all(3.sp),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppConfig.colors.themeColor,
                ),
                child: Text(
                  "${appProvider.userActiveBookings.length}",
                  style: latoRegular.copyWith(fontSize: 10.sp,color: AppConfig.colors.whiteColor),
                ),
              )
            : SizedBox.shrink(),
      ],
    ),
  );
}

GestureDetector appBarIcons({required Function onTab, required String icon}) {
  return GestureDetector(
    onTap: () {
      onTab();
    },
    child: Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: 37.h,
          height: 38.h,
          decoration: BoxDecoration(
            color: const Color(0xffF5F4F4),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(8.sp),
          child: Image.asset(
            icon,
            color: AppConfig.colors.themeColor,
            fit: BoxFit.contain,
            width: 16.w,
            height: 20.h,
          ),
        ),
        Provider.of<AppProvider>(Get.context!, listen: false).isSeenNotification
            ? Container(
                width: 10.h,
                height: 10.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppConfig.colors.themeColor,
                ),
              )
            : SizedBox.shrink(),
      ],
    ),
  );
}

