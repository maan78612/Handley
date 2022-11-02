import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:social_pro/UI/Bookings/widgets/rating.dart';

import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/model_classes/booking_model.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/ui/shared/custom_dialog.dart';
import 'package:social_pro/ui/shared/empty_screen.dart';
import 'package:social_pro/ui/shared/location_btn.dart';

import 'package:social_pro/utilities/enums.dart';
import 'package:social_pro/constants/styles.dart';

class Bookings extends StatefulWidget {
  Bookings({Key? key}) : super(key: key);

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> with TickerProviderStateMixin {
  late TabController _controller;

  TextEditingController ratingController = TextEditingController();

  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    super.initState();
    _controller = TabController(
        length: 3, vsync: this, initialIndex: appProvider.bookingTabIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, AppProvider>(
        builder: (context, authProvider, appProvider, _) {
      return Scaffold(
        backgroundColor: AppConfig.colors.whiteColor,
        body: Column(
          children: [
            SizedBox(
              height: 35.h,
              child: TabBar(
                controller: _controller,
                onTap: (index) {
                  setState(() {
                    appProvider.bookingTabIndex = index;
                  });
                },
                padding: EdgeInsets.zero,
                /* remove default indicator*/
                indicatorColor: Colors.transparent,
                tabs: [
                  tabBarHeader("History", 0, appProvider),
                  tabBarHeader("Pending", 1, appProvider),
                  tabBarHeader("Active", 2, appProvider),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: [
                  previous(authProvider, appProvider),
                  pending(authProvider, appProvider),
                  active(authProvider, appProvider),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget previous(AuthProvider authProvider, AppProvider appProvider) {
    /* Get all previous bookings*/

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 20.h),
          child: Text(
            "Previous Services",
            textAlign: TextAlign.center,
            style: latoBlack.copyWith(
                fontSize: 16.sp, color: AppConfig.colors.secondaryThemeColor),
          ),
        ),
        Expanded(
          child: appProvider.userPreviousBookings.isEmpty
              ? Center(
                  child: EmptyScreen(
                      message: "No previous services",
                      image: AppConfig.images.bookings),
                )
              : ListView(
                  children: List.generate(
                      appProvider.userPreviousBookings.length, (index) {
                    BookingModel bookings =
                        appProvider.userPreviousBookings[index];

                    if (AppUser.user.userType == UserType.customer) {
                      bookings.userData = authProvider.allUser.firstWhere(
                          (element) => element.email == bookings.proId);
                      return bookingCardForCustomer(
                          authProvider, bookings, appProvider);
                    } else {
                      bookings.userData = authProvider.allUser.firstWhere(
                          (element) => element.email == bookings.customerId);
                      return bookingCardProfessional(
                          authProvider, bookings, appProvider);
                    }
                  }),
                ),
        ),
      ],
    );
  }

  Widget pending(AuthProvider authProvider, AppProvider appProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 20.h),
          child: Text(
            "Pending Services",
            textAlign: TextAlign.center,
            style: latoBlack.copyWith(
                fontSize: 16.sp, color: AppConfig.colors.secondaryThemeColor),
          ),
        ),
        Expanded(
          child: appProvider.userPendingBookings.isEmpty
              ? Center(
                  child: EmptyScreen(
                      message: "No pending services",
                      image: AppConfig.images.bookings),
                )
              : ListView(
                  children: List.generate(
                      appProvider.userPendingBookings.length, (index) {
                  BookingModel bookings =
                      appProvider.userPendingBookings[index];

                  if (AppUser.user.userType == UserType.customer) {
                    bookings.userData = authProvider.allUser.firstWhere(
                        (element) => element.email == bookings.proId);
                    return bookingCardForCustomer(
                        authProvider, bookings, appProvider);
                  } else {
                    bookings.userData = authProvider.allUser.firstWhere(
                        (element) => element.email == bookings.customerId);
                    return bookingCardProfessional(
                        authProvider, bookings, appProvider);
                  }
                })),
        ),
      ],
    );
  }

  Widget active(AuthProvider authProvider, AppProvider appProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 20.h),
          child: Text(
            "Active Services",
            textAlign: TextAlign.center,
            style: latoBlack.copyWith(
                fontSize: 16.sp, color: AppConfig.colors.secondaryThemeColor),
          ),
        ),
        Expanded(
          child: appProvider.userActiveBookings.isEmpty
              ? Center(
                  child: EmptyScreen(
                      message: "No active services",
                      image: AppConfig.images.bookings),
                )
              : ListView(
                  children: List.generate(appProvider.userActiveBookings.length,
                      (index) {
                    BookingModel bookings =
                        appProvider.userActiveBookings[index];

                    if (AppUser.user.userType == UserType.customer) {
                      bookings.userData = authProvider.allUser.firstWhere(
                          (element) => element.email == bookings.proId);
                      return bookingCardForCustomer(
                          authProvider, bookings, appProvider);
                    } else {
                      bookings.userData = authProvider.allUser.firstWhere(
                          (element) => element.email == bookings.customerId);
                      return bookingCardProfessional(
                          authProvider, bookings, appProvider);
                    }
                  }),
                ),
        ),
      ],
    );
  }

  Widget tabBarHeader(String title, int index, AppProvider appProvider) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.sp),
          color: appProvider.bookingTabIndex == index
              ? AppConfig.colors.themeColor
              : Color(0xffFDEEED)),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: appProvider.bookingTabIndex == index
            ? latoBold.copyWith(
                fontSize: 16.sp, color: AppConfig.colors.whiteColor)
            : latoRegular.copyWith(
                fontSize: 16.sp,
                color: AppConfig.colors.secondaryThemeColor.withOpacity(0.3)),
      ),
    );
  }

  Widget bookingCardForCustomer(AuthProvider authProvider,
      BookingModel bookingData, AppProvider appProvider) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.all(4.sp),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.sp),
                  border: Border.all(color: AppConfig.colors.themeColor)),
              child: bookingData.userData!.imageUrl != ""
                  ? CachedNetworkImage(
                      imageUrl: bookingData.userData!.imageUrl,
                      fit: BoxFit.cover,
                      width: 50.w,
                      height: 50.h,
                    )
                  : Padding(
                      padding: EdgeInsets.all(10.0.sp),
                      child: Image.asset(
                        AppConfig.images.account,
                        color: AppConfig.colors.themeColor,
                        fit: BoxFit.contain,
                        width: 30.w,
                        height: 30.h,
                      ),
                    )),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  cardHeaderLineCustomer(
                      bookingData,
                      appProvider,
                      (bookingData.bookingType == BookingType.complete)
                          ? "Service Completed"
                          : (bookingData.bookingType == BookingType.cancel)
                              ? "Service Cancelled"
                              : (bookingData.bookingType == BookingType.pending)
                                  ? "Service Pending"
                                  : "Service Active",
                      authProvider),
                  SizedBox(height: 10.h),
                  cardInfoLines(
                      title: "PROFESSIONAL NAME",
                      data:
                          "${bookingData.userData!.firstName} ${bookingData.userData!.lastName}"),
                  cardInfoLines(
                      title: "SERVICE",
                      data: "${bookingData.userData!.profession!.title}"),
                  if (bookingData.bookingType == BookingType.pending ||
                      bookingData.bookingType == BookingType.active)
                    cardInfoLines(
                        title: "BOOKING DATE",
                        data:
                            "${DateFormat('hh:mm a').format(bookingData.bookingDate!.toDate())} - ${DateFormat.yMd().format(bookingData.bookingDate!.toDate())}"),
                  if (bookingData.bookingType == BookingType.complete)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text("RATING",
                              style: latoBold.copyWith(fontSize: 10.sp)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                (bookingData.rating != null)
                                    ? "${bookingData.rating!.rating!.toStringAsFixed(2)} "
                                    : " - ",
                                style: latoBold.copyWith(fontSize: 10.sp)),
                            Icon(
                              Icons.star,
                              size: 10.sp,
                              color: Color(0xffE6C65C),
                            ),
                          ],
                        )
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bookingCardProfessional(AuthProvider authProvider,
      BookingModel bookingData, AppProvider appProvider) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.all(4.sp),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.sp),
                  border: Border.all(color: AppConfig.colors.themeColor)),
              child: bookingData.userData!.imageUrl != ""
                  ? CachedNetworkImage(
                      imageUrl: bookingData.userData!.imageUrl,
                      fit: BoxFit.cover,
                      width: 50.w,
                      height: 50.h,
                    )
                  : Padding(
                      padding: EdgeInsets.all(10.0.sp),
                      child: Image.asset(
                        AppConfig.images.account,
                        color: AppConfig.colors.themeColor,
                        fit: BoxFit.contain,
                        width: 30.w,
                        height: 30.h,
                      ),
                    )),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  cardHeaderLineProfessional(
                      bookingData,
                      appProvider,
                      (bookingData.bookingType == BookingType.complete)
                          ? "Service Completed"
                          : (bookingData.bookingType == BookingType.cancel)
                              ? "Service Cancelled"
                              : (bookingData.bookingType == BookingType.pending)
                                  ? "Service Pending"
                                  : "Service Active"),
                  SizedBox(height: 10.h),
                  cardInfoLines(
                      title: "CUSTOMER NAME",
                      data:
                          "${bookingData.userData!.firstName} ${bookingData.userData!.lastName}"),
                  if (bookingData.bookingType == BookingType.complete)
                    cardInfoLines(
                        title: "COMPLETION DATE",
                        data:
                            "${DateFormat('hh:mm a').format(bookingData.finishedAt!.toDate())} - ${DateFormat.yMd().format(bookingData.finishedAt!.toDate())}"),
                  cardInfoLines(
                      title: "BOOKING DATE",
                      data:
                          "${DateFormat('hh:mm a').format(bookingData.bookingDate!.toDate())} - ${DateFormat.yMd().format(bookingData.bookingDate!.toDate())}"),
                  if (bookingData.bookingType != BookingType.complete)
                    cardInfoLines(
                        title: "ADDRESS",
                        data: "${bookingData.bookingAddress.address}"),
                  if (bookingData.bookingType == BookingType.complete)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text("JOB RATING",
                              style: latoBold.copyWith(fontSize: 10.sp)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                (bookingData.rating != null)
                                    ? "${bookingData.rating!.rating!.toStringAsFixed(2)} "
                                    : " - ",
                                style: latoBold.copyWith(fontSize: 10.sp)),
                            Icon(
                              Icons.star,
                              size: 10.sp,
                              color: Color(0xffE6C65C),
                            ),
                          ],
                        )
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row cardHeaderLineProfessional(
      BookingModel bookingData, AppProvider appProvider, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: latoBold.copyWith(
                fontSize: 16.sp,
                color: (bookingData.bookingType == BookingType.complete)
                    ? Color(0xff509937)
                    : AppConfig.colors.themeColor),
          ),
        ),
        if (bookingData.bookingType == BookingType.pending)
          Row(
            children: [
              cancelBookingBtn(appProvider, bookingData),
              SizedBox(width: 10.w),
              acceptBookingBtn(appProvider, bookingData)
            ],
          ),
        if (bookingData.bookingType == BookingType.active)
          Row(
            children: [
              cancelBookingBtn(appProvider, bookingData),
              SizedBox(width: 10.w),
              locationBtn(
                  bookingData, Color(0xffFDEEED), AppConfig.colors.themeColor)
            ],
          ),
      ],
    );
  }

  Row cardHeaderLineCustomer(BookingModel bookingData, AppProvider appProvider,
      String title, AuthProvider authProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: latoBold.copyWith(
                fontSize: 16.sp,
                color: (bookingData.bookingType == BookingType.complete)
                    ? Color(0xff509937)
                    : AppConfig.colors.themeColor),
          ),
        ),
        if (bookingData.bookingType == BookingType.pending)
          cancelBookingBtn(appProvider, bookingData),
        if (bookingData.bookingType == BookingType.active)
          Row(
            children: [
              cancelBookingBtn(appProvider, bookingData),
              SizedBox(width: 10.w),
              completeBookingBtn(authProvider, bookingData, appProvider),
            ],
          ),
        if (bookingData.bookingType == BookingType.complete &&
            bookingData.rating == null)
          giveRatingBtn(bookingData, appProvider),
      ],
    );
  }

  Column cardInfoLines({required String data, required String title}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: latoBold.copyWith(
                  fontSize: 10.sp, color: AppConfig.colors.secondaryThemeColor),
            ),
            Expanded(
              child: Text(
                data,
                textAlign: TextAlign.end,
                style: latoRegular.copyWith(
                    fontSize: 10.sp,
                    color: AppConfig.colors.secondaryThemeColor),
              ),
            ),
          ],
        ),
        Divider(
          color: Color(0xffD9D4D5),
          height: 5.sp,
        ),
      ],
    );
  }

  /*==================== Accept booking ======================== */
  Widget acceptBookingBtn(
      AppProvider appProvider, BookingModel acceptedBooking) {
    return GestureDetector(
      onTap: () async {
        await appProvider.acceptBooking(acceptedBooking);
        /* After accepting bookings we cancel all other bookings of same time and send notification*/
        await Future.forEach(appProvider.allBookings,
            (BookingModel booking) async {
          DateTime bDate = booking.bookingDate!.toDate();
          if (bDate.compareTo(acceptedBooking.bookingDate!.toDate()) == 0) {
            if (booking.bookingID != acceptedBooking.bookingID) {
              await appProvider.cancelBooking(booking);
            }
          }
        });
      },
      child: Container(
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            color: Color(0xffF1FDED),
            borderRadius: BorderRadius.circular(10.sp),
          ),
          child: Container(
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
    );
  }

  /*==================== Decline booking ======================== */
  Widget cancelBookingBtn(AppProvider appProvider, BookingModel bookingData) {
    return GestureDetector(
      onTap: () async {
        await cancelBookingOnPress(appProvider, bookingData);
      },
      child: Container(
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            color: Color(0xffFDEEED),
            borderRadius: BorderRadius.circular(10.sp),
          ),
          child: Icon(
            Icons.cancel_outlined,
            size: 19.sp,
            color: Colors.red,
          )),
    );
  }

  /*==================== Finish booking ======================== */
  Widget completeBookingBtn(AuthProvider authProvider, BookingModel bookingData,
      AppProvider appProvider) {
    return InkWell(
      onTap: () async {
        await completeBookingOnPress(authProvider, bookingData, appProvider);
      },
      child: Container(
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            color: Color(0xffF1FDED),
            borderRadius: BorderRadius.circular(10.sp),
          ),
          child: Container(
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
    );
  }

  Future<void> completeBookingOnPress(AuthProvider authProvider,
      BookingModel bookingData, AppProvider appProvider) async {
    await appProvider.completeBooking(bookingData);

    /* After complete booking update job umber */
    UserData professionalData = authProvider.allUser
        .where((element) => element.email == bookingData.proId)
        .first;
    professionalData.numberOfJobs = professionalData.numberOfJobs! + 1;

    await appProvider.updateProfessional(professional: professionalData);
    print(
        "Job has been completed Now ${professionalData.email} done ${professionalData.numberOfJobs} jobs");
    giveRatingOnPress(bookingData, appProvider);
  }

  /*==================== Cancel booking ======================== */

  Future<void> cancelBookingOnPress(
      AppProvider appProvider, BookingModel bookingData) async {
    bool isBookCancel = await CustomDialog.showConfirmationDialog(
        context, "Are you sure you want to cancel booking?");
    if (isBookCancel) {
      await appProvider.cancelBooking(bookingData);
    }
  }

  /*==================== Give Rating======================== */
  Widget giveRatingBtn(BookingModel bookingData, AppProvider appProvider) {
    return InkWell(
      onTap: () async {
        giveRatingOnPress(bookingData, appProvider);
      },
      child: Container(
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            color: Color(0xffFDF8ED),
            borderRadius: BorderRadius.circular(10.sp),
          ),
          child: Icon(
            Icons.star,
            size: 14.sp,
            color: Color(0xffE6C65C),
          )),
    );
  }

  void giveRatingOnPress(BookingModel bookingData, AppProvider appProvider) {
    ratingController.clear();
    appProvider.ratingValue = 0;
    Get.dialog(
        RatingDialog(
          ratingController: ratingController,
          bookingData: bookingData,
        ),
        barrierDismissible: false);
  }
}
