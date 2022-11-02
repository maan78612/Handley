import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/model_classes/booking_model.dart';
import 'package:social_pro/model_classes/notification.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/ui/shared/custom_app_bar.dart';
import 'package:social_pro/ui/shared/custom_dialog.dart';
import 'package:social_pro/ui/shared/empty_screen.dart';
import 'package:social_pro/utilities/enums.dart';
import 'package:social_pro/constants/styles.dart';

class AppNotifications extends StatefulWidget {
  @override
  _AppNotificationsState createState() => _AppNotificationsState();
}

class _AppNotificationsState extends State<AppNotifications> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<AppProvider>(context, listen: false)
          .makeAllNotificationRead();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, AuthProvider>(
        builder: (context, appProvider, authProvider, _) {
      return ModalProgressHUD(
        inAsyncCall: appProvider.isLoading,
        child: Scaffold(
          backgroundColor: AppConfig.colors.whiteColor,
          appBar: customAppBar(
              onTab: () {
                Get.back();
              },
              title: ""),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Notifications",
                      style: latoBlack.copyWith(
                          fontSize: 16.sp,
                          color: AppConfig.colors.secondaryThemeColor),
                    ),
                    if (appProvider.userNotifications.isNotEmpty)
                      TextButton(
                        onPressed: () async {
                          bool isClear =
                              await CustomDialog.showConfirmationDialog(
                                  context,
                                  "Are you sure you want to clear all Notifications ?");
                          if (isClear) {
                            appProvider.deleteAllNotifications();
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                AppConfig.colors.whiteColor)),
                        child: Text(
                          "Clear Notifications",
                          style: latoBold.copyWith(
                              fontSize: 12.sp,
                              color: AppConfig.colors.themeColor),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: (appProvider.userNotifications.isNotEmpty)
                    ? ListView(
                        children: List.generate(
                            appProvider.userNotifications.length, (index) {
                          NotificationModal notification =
                              appProvider.userNotifications[index];
                          UserData notificationUserData = authProvider.allUser
                              .where((element) =>
                                  element.email == notification.sender)
                              .toList()
                              .first;

                          return notificationCard(notification, appProvider,
                              index, notificationUserData);
                        }),
                      )
                    : EmptyScreen(
                        message: "No Notifications",
                        image: AppConfig.images.notification),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget notificationCard(NotificationModal notification,
      AppProvider appProvider, int index, UserData notificationUserData) {
    /* ==== Note : For booking type (which we are using to show different notification card design)  we cannot fetch real time data from booking document
    because once we change status of booking fro example from Pending to active
    it will reflect in notification and effect notification card design
    because notification card design is different for pending , active , previous booking statuses
    For that we store booking model class in notification as well to get exact booking type at notification sending time
    ====== */

    /* get updatedUserBookingData because once we send notification we cannot
    update its rating in notification document booking model So we fetch it from booking
    document from booking id*/

    BookingModel updatedUserBookingData = appProvider.userBookings
        .where((element) =>
            element.bookingID == notification.bookingData!.bookingID)
        .toList()
        .first;

    return Padding(
      padding: EdgeInsets.all(8.0.sp),
      child: ListTile(
        contentPadding: EdgeInsets.all(12.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.sp)),
          side: BorderSide(
            color: Color(0xffD9D4D5),
            width: 1,
          ),
        ),
        tileColor: AppConfig.colors.whiteColor,
        leading: Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: notification.bookingData!.bookingType ==
                          BookingType.pending ||
                      notification.bookingData!.bookingType ==
                          BookingType.cancel
                  ? Color(0xffFDEEED)
                  : Color(0xffF1FDED),
              borderRadius: BorderRadius.circular(100.sp),
            ),
            child: notification.bookingData!.bookingType ==
                        BookingType.pending ||
                    notification.bookingData!.bookingType == BookingType.cancel
                ? Padding(
                    padding: EdgeInsets.all(2.0.sp),
                    child: Image.asset(
                      AppConfig.images.bookings,
                      color: AppConfig.colors.themeColor,
                      width: 12,
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(2.sp),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.sp),
                        border: Border.all(width: 1, color: Color(0xff509937))),
                    child: Icon(
                      Icons.done,
                      size: 12.sp,
                      color: Color(0xff509937),
                    ),
                  )),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(notification.title,
                        style: latoBold.copyWith(fontSize: 14.sp))),
                Text(
                  "DATE",
                  style: latoBold.copyWith(fontSize: 10.sp),
                ),
                SizedBox(width: 3.sp),
                Text(
                  DateFormat.yMd().format(notification.createdAt.toDate()),
                  style: latoRegular.copyWith(fontSize: 10.sp),
                )
              ],
            ),
            Text(notification.body,
                style: latoRegular.copyWith(fontSize: 12.sp)),
            SizedBox(height: 20.h),
          ],
        ),
        subtitle: (notification.bookingData!.bookingType ==
                BookingType.complete)
            ? serviceCompleted(notificationUserData, updatedUserBookingData)
            : (notification.bookingData!.bookingType == BookingType.pending)
                ? bookingRequested(notificationUserData, notification)
                : (notification.bookingData!.bookingType == BookingType.cancel)
                    ? bookingCancelled(notificationUserData, notification)
                    : bookingAccepted(notificationUserData, notification),
      ),
    );
  }

  Column bookingAccepted(
      UserData notificationUserData, NotificationModal notification) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text("PROFESSIONAL NAME",
                  style: latoBold.copyWith(fontSize: 10.sp)),
            ),
            Text(
                "${notificationUserData.firstName} ${notificationUserData.lastName}",
                style: latoBold.copyWith(fontSize: 10.sp)),
          ],
        ),
        Divider(color: Color(0xffD9D4D5)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text("BOOKING DATE",
                  style: latoBold.copyWith(fontSize: 10.sp)),
            ),
            Text(
                "${DateFormat.yMd().format(notification.bookingData!.bookingDate!.toDate())} - ${DateFormat('hh:mm a').format(notification.bookingData!.bookingDate!.toDate())} ",
                style: latoBold.copyWith(fontSize: 10.sp)),
          ],
        ),
      ],
    );
  }

  Column bookingCancelled(
      UserData notificationUserData, NotificationModal notification) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                  AppUser.user.userType == UserType.customer
                      ? "PROFESSIONAL NAME"
                      : "CUSTOMER NAME",
                  style: latoBold.copyWith(fontSize: 10.sp)),
            ),
            Text(
                "${notificationUserData.firstName} ${notificationUserData.lastName}",
                style: latoBold.copyWith(fontSize: 10.sp)),
          ],
        ),
        Divider(color: Color(0xffD9D4D5)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text("BOOKING DATE",
                  style: latoBold.copyWith(fontSize: 10.sp)),
            ),
            Text(
              "${DateFormat.yMd().format(notification.bookingData!.bookingDate!.toDate())} - ${DateFormat('hh:mm a').format(notification.bookingData!.bookingDate!.toDate())} ",
              style: latoRegular.copyWith(fontSize: 10.sp),
            ),
          ],
        ),
      ],
    );
  }

  Column bookingRequested(
      UserData notificationUserData, NotificationModal notification) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text("CUSTOMER NAME",
                  style: latoBold.copyWith(fontSize: 10.sp)),
            ),
            Text(
                "${notificationUserData.firstName} ${notificationUserData.lastName}",
                style: latoBold.copyWith(fontSize: 10.sp)),
          ],
        ),
        Divider(color: Color(0xffD9D4D5)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text("BOOKING DATE",
                  style: latoBold.copyWith(fontSize: 10.sp)),
            ),
            Text(
              "${DateFormat.yMd().format(notification.bookingData!.bookingDate!.toDate())} - ${DateFormat('hh:mm a').format(notification.bookingData!.bookingDate!.toDate())} ",
              style: latoRegular.copyWith(fontSize: 10.sp),
            ),
          ],
        ),
      ],
    );
  }

  Column serviceCompleted(
      UserData notificationUserData, BookingModel updatedUserBookingData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text("CUSTOMER NAME",
                  style: latoBold.copyWith(fontSize: 10.sp)),
            ),
            Text(
                "${notificationUserData.firstName} ${notificationUserData.lastName}",
                style: latoBold.copyWith(fontSize: 10.sp)),
          ],
        ),
        Divider(color: Color(0xffD9D4D5)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child:
                  Text("JOB RATING", style: latoBold.copyWith(fontSize: 10.sp)),
            ),
            if (updatedUserBookingData.rating != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "${updatedUserBookingData.rating!.rating!.toStringAsFixed(2)} ",
                      style: latoBold.copyWith(fontSize: 10.sp)),
                  Icon(
                    Icons.star,
                    size: 10.sp,
                    color: Color(0xffE6C65C),
                  ),
                ],
              )
            else
              Text("Not Given",
                  style: latoBold.copyWith(
                      fontSize: 10.sp, color: AppConfig.colors.themeColor)),
          ],
        ),
        Divider(color: Color(0xffD9D4D5)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text("FINISH DATE",
                  style: latoBold.copyWith(fontSize: 10.sp)),
            ),
            Text(
              "${DateFormat.yMd().format(updatedUserBookingData.finishedAt!.toDate())} - ${DateFormat('hh:mm a').format(updatedUserBookingData.finishedAt!.toDate())} ",
              style: latoRegular.copyWith(fontSize: 10.sp),
            ),
          ],
        ),
      ],
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: latoRegular.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}
