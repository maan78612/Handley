import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/model_classes/booking_model.dart';
import 'package:social_pro/model_classes/disableDates.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/provider/calender_provider.dart';
import 'package:social_pro/ui/bookings/widgets/booking_location_shimmer.dart';
import 'package:social_pro/ui/bookings/widgets/timeslot_sheet.dart';
import 'package:social_pro/ui/dashoard/dashboard.dart';
import 'package:social_pro/ui/more/saved_addresses/saved_addresses.dart';
import 'package:social_pro/ui/shared/app_button.dart';
import 'package:social_pro/ui/shared/custom_app_bar.dart';
import 'package:social_pro/ui/shared/custom_dialog.dart';
import 'package:social_pro/ui/shared/custom_loader.dart';
import 'package:social_pro/ui/shared/location_btn.dart';
import 'package:social_pro/utilities/enums.dart';
import 'package:table_calendar/table_calendar.dart';

final kNow = DateTime.now();
final kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
final kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);

class BookingDetails extends StatefulWidget {
  List<BookingModel> bookingList;
  UserData professionalUser;

  BookingDetails({required this.bookingList, required this.professionalUser});

  @override
  State<StatefulWidget> createState() => _BookingDetailState(
      bookingList: bookingList, professionalUser: professionalUser);
}

class _BookingDetailState extends State<BookingDetails> {
  List<BookingModel> bookingList;
  UserData professionalUser;

  _BookingDetailState(
      {required this.bookingList, required this.professionalUser});

  PageController _pageController = PageController();
  DisableDates? disableDate;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      CalenderProvider calenderProvider =
          Provider.of<CalenderProvider>(context, listen: false);
      AuthProvider authProvider =
          Provider.of<AuthProvider>(context, listen: false);
      await calenderProvider.onStart(bookingList);
      if (AppUser.user.userType == UserType.professional)
        disableDate =
            authProvider.checkDisableDates(calenderProvider.selectedDate);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<CalenderProvider, AuthProvider, AppProvider>(
        builder: (context, calenderProvider, authProvider, appProvider, _) {
      return ModalProgressHUD(
        inAsyncCall: authProvider.isLoading,
        progressIndicator: customLoader(),
        child: Scaffold(
          backgroundColor: AppConfig.colors.whiteColor,
          appBar: customAppBar(
              onTab: () {
                Get.back();
              },
              title: "Booking"),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 20.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (AppUser.user.userType == UserType.customer)
                    professionalInfo(),
                  if (AppUser.user.userType == UserType.customer)
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0.sp),
                      child: Text(
                        "Calendar",
                        style: latoBlack.copyWith(
                            fontSize: 16.sp,
                            color: AppConfig.colors.secondaryThemeColor),
                      ),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "View Schedule",
                                style: latoBlack.copyWith(
                                    fontSize: 16.sp,
                                    color:
                                        AppConfig.colors.secondaryThemeColor),
                              ),
                              SizedBox(height: 5.sp),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "SELECTED DATE",
                                    style: latoRegular.copyWith(
                                        fontSize: 10.sp,
                                        color: AppConfig
                                            .colors.secondaryThemeColor),
                                  ),
                                  SizedBox(width: 5.sp),
                                  Text(
                                    DateFormat.yMd()
                                        .format(calenderProvider.selectedDate),
                                    style: latoBold.copyWith(
                                        fontSize: 10.sp,
                                        color: AppConfig.colors.themeColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          if (disableDate != null &&
                              disableDate!.isDisable == true)
                            enableDateBtn(authProvider: authProvider)
                          else
                            disableDateBtn(
                                authProvider: authProvider,
                                date: Timestamp.fromDate(
                                    calenderProvider.selectedDate),
                                calenderProvider: calenderProvider)
                        ],
                      ),
                    ),
                  bookingCalender(calenderProvider, authProvider),
                  if (AppUser.user.userType == UserType.professional &&
                      calenderProvider.selectedDayBookings.length > 0)
                    bookingListOnSelectedDay(calenderProvider, authProvider),
                  TimeSlot(
                    proID: professionalUser.email,
                    customerID: AppUser.user.email,
                  ),
                  if (AppUser.user.userType == UserType.customer)
                    bookingLocation(appProvider),
                  SizedBox(height: 20.sp),
                ],
              ),
            ),
          ),
          bottomNavigationBar: AppUser.user.userType == UserType.customer
              ? SizedBox(
                  height: 120.h,
                  child: appButton(
                      textColor: AppConfig.colors.whiteColor,
                      btnColor: (calenderProvider.selectDateTmeSlot != null &&
                              appProvider.selectedAddress != null)
                          ? AppConfig.colors.themeColor
                          : Colors.grey[500],
                      title: 'BOOK',
                      isIcon: false,
                      onTab: () async {
                        if (calenderProvider.selectDateTmeSlot != null &&
                            appProvider.selectedAddress != null) {
                          bool isBook = await CustomDialog.showConfirmationDialog(
                              context,
                              "Are you sure you want to book at ${DateFormat.yMMMd().format(calenderProvider.selectDateTmeSlot!)} at ${DateFormat.jm().format(calenderProvider.selectDateTmeSlot!)}?");
                          if (isBook) {
                            Timestamp bookingTimestamp = Timestamp.fromDate(
                                calenderProvider.selectDateTmeSlot!);
                            await appProvider.setBooking(BookingModel(
                                customerId: AppUser.user.email,
                                proId: professionalUser.email,
                                bookingStatus: BookingType.pending.index,
                                bookingDate: bookingTimestamp,
                                bookingAddress: appProvider.userSavedAddress
                                    .where((element) =>
                                        element.addressID ==
                                        AppUser.user.selectedAddressID)
                                    .first));
                            Get.off(DashBoard(index: 0));
                          }
                        } else if (calenderProvider.selectDateTmeSlot == null) {
                          Get.snackbar(
                              "Select Time", "Please select time to proceed",
                              colorText: AppConfig.colors.whiteColor,
                              backgroundColor: AppConfig.colors.themeColor);
                        } else {
                          Get.snackbar("Select Location",
                              "Please select booking location to proceed",
                              colorText: AppConfig.colors.whiteColor,
                              backgroundColor: AppConfig.colors.themeColor);
                        }
                      }),
                )
              : SizedBox.shrink(),
        ),
      );
    });
  }

  /*=========================== Professional Info (Both Customer & Professional) ==========================*/
  Column professionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 20.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.all(4.sp),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppConfig.colors.themeColor)),
                child: professionalUser.imageUrl != ""
                    ? CachedNetworkImage(
                        imageUrl: professionalUser.imageUrl,
                        fit: BoxFit.cover,
                        width: 67.w,
                        height: 68.h,
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.sp),
                        child: Image.asset(
                          AppConfig.images.account,
                          color: AppConfig.colors.themeColor,
                          fit: BoxFit.contain,
                          width: 67.w,
                          height: 48.h,
                        ),
                      )),
            SizedBox(width: 20.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${professionalUser.firstName} ${professionalUser.lastName}",
                  style: latoRegular.copyWith(
                    fontSize: 16.sp,
                    color: AppConfig.colors.secondaryThemeColor,
                  ),
                ),
                Text(
                  professionalUser.profession!.title,
                  style: latoBold.copyWith(
                    fontSize: 12.sp,
                    color: AppConfig.colors.secondaryThemeColor,
                  ),
                ),
                SizedBox(height: 7.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 5.sp,
                      height: 5.sp,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppConfig.colors.secondaryThemeColor,
                      ),
                    ),
                    Text(
                      '  ${professionalUser.experience} years experience',
                      style: latoBold.copyWith(
                          fontSize: 11.sp,
                          color: AppConfig.colors.secondaryThemeColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 5.sp,
                      height: 5.sp,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppConfig.colors.secondaryThemeColor,
                      ),
                    ),
                    Text(
                      '  ${professionalUser.satisfactionPercentage?.toInt()}% ',
                      style: latoBold.copyWith(
                          fontSize: 11.sp,
                          color: AppConfig.colors.secondaryThemeColor),
                    ),
                    Text(
                      'customer satisfaction',
                      style: latoBold.copyWith(
                          fontSize: 10.sp,
                          color: AppConfig.colors.secondaryThemeColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Text(
              "${professionalUser.rating?.toStringAsFixed(1)}",
              style: latoBold.copyWith(
                  fontSize: 12.sp, color: AppConfig.colors.secondaryThemeColor),
            ),
            SizedBox(width: 5.w),
            Icon(Icons.star, color: Colors.yellow, size: 16.sp),
          ],
        ),
        SizedBox(height: 10.sp),
        Text(
          "Description",
          style: latoBlack.copyWith(
              fontSize: 16.sp, color: AppConfig.colors.secondaryThemeColor),
        ),
        SizedBox(height: 10.sp),
        Text(
          professionalUser.description!,
          style: latoRegular.copyWith(
              fontSize: 12.sp, color: AppConfig.colors.secondaryThemeColor),
        ),
        SizedBox(height: 10.sp),
      ],
    );
  }

  /*=========================== Calender (Both Customer & Professional) ==========================*/
  TableCalendar<dynamic> bookingCalender(
      CalenderProvider calenderProvider, AuthProvider authProvider) {
    return TableCalendar(
      enabledDayPredicate: (date) {
        return (date.difference(calenderProvider.currentDate).inDays) >= 0;
      },

      rowHeight: 40.sp,
      daysOfWeekHeight: 18.sp,
      focusedDay: calenderProvider.selectedDate,
      selectedDayPredicate: (day) =>
          isSameDay(day, calenderProvider.selectedDate),
      firstDay: kFirstDay,
      lastDay: kLastDay,
      eventLoader: (AppUser.user.userType == UserType.professional)
          ? calenderProvider.getEventsForDay
          : null,
      onDaySelected: (selectedDay, focusedDay) async {
        calenderProvider.selectDay(selectedDay);
        if (AppUser.user.userType == UserType.professional)
          disableDate =
              authProvider.checkDisableDates(calenderProvider.selectedDate);
      },
      weekendDays: const [6],

      headerStyle: HeaderStyle(
        decoration: BoxDecoration(
          color: AppConfig.colors.themeColor,
          borderRadius: BorderRadius.circular(12.sp),
        ),
        headerMargin: const EdgeInsets.only(bottom: 8.0),
        titleTextStyle: latoRegular.copyWith(
            color: AppConfig.colors.whiteColor, fontSize: 16.sp),
        titleCentered: true,
        formatButtonVisible: false,
        // formatButtonDecoration: BoxDecoration(
        //   border: Border.all(color: Colors.white),
        //   borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        // ),
        // formatButtonTextStyle: latoBold.copyWith(
        //     color: AppConfig.colors.whiteColor, fontSize: 14.sp),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: Colors.white,
          size: 25.sp,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: Colors.white,
          size: 25.sp,
        ),
      ),

      calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          cellMargin: EdgeInsets.all(6.sp),
          /* Text Styles*/
          disabledTextStyle:
              latoRegular.copyWith(color: Color(0xff3A333559), fontSize: 12.sp),
          defaultTextStyle: latoRegular.copyWith(
              color: AppConfig.colors.secondaryThemeColor, fontSize: 12.sp),
          weekendTextStyle: latoRegular.copyWith(
              color: AppConfig.colors.secondaryThemeColor, fontSize: 12.sp),
          todayTextStyle:
              latoRegular.copyWith(color: Color(0xff0093FF), fontSize: 12.sp),
          selectedTextStyle: latoRegular.copyWith(
              color: AppConfig.colors.whiteColor, fontSize: 12.sp),
          /* Default  Styles =====> note uses shape: BoxShape.rectangle */
          /*default decorations in CalendarStyle use BoxShape.circle. which gives error when change style so */
          todayDecoration: BoxDecoration(
              color: Colors.transparent, shape: BoxShape.rectangle),
          defaultDecoration: BoxDecoration(color: Colors.transparent),
          weekendDecoration: BoxDecoration(shape: BoxShape.rectangle),
          selectedDecoration: BoxDecoration(
              color: AppConfig.colors.themeColor,
              borderRadius: BorderRadius.circular(6.sp),
              shape: BoxShape.rectangle)),

      calendarBuilders: const CalendarBuilders(),
      calendarFormat: CalendarFormat.month,
      // onFormatChanged: (format) {
      //   if (calenderProvider.calendarFormat != format) {
      //     // Call `setState()` when updating calendar format
      //     setState(() {
      //       calenderProvider.calendarFormat = format;
      //     });
      //   }
      // },
    );
  }

  /*=========================== Booking Lists (Professional) ==========================*/
  Widget bookingListOnSelectedDay(
      CalenderProvider calenderProvider, AuthProvider authProvider) {
    return Column(
      children: [
        SizedBox(
          height: 100.h,
          child: PageView.builder(
            pageSnapping: false,
            physics: PageScrollPhysics(),
            controller: _pageController,
            scrollDirection: Axis.horizontal,

            itemCount: calenderProvider.selectedDayBookings.length,
            // scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              BookingModel booking =
                  calenderProvider.selectedDayBookings[index];
              booking.userData = authProvider.allUser
                  .firstWhere((element) => element.email == booking.customerId);

              return Container(
                  padding: EdgeInsets.all(8.sp),
                  margin: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.sp),
                    color: Color(0xffFDEEED),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.all(8.sp),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.sp),
                              border: Border.all(
                                  color: AppConfig.colors.themeColor)),
                          child: (booking.userData?.imageUrl ?? "") != ""
                              ? CachedNetworkImage(
                                  imageUrl: booking.userData!.imageUrl,
                                  fit: BoxFit.cover,
                                  width: 45.w,
                                  height: 45.h,
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.sp),
                                  child: Image.asset(
                                    AppConfig.images.account,
                                    color: AppConfig.colors.themeColor,
                                    fit: BoxFit.contain,
                                    width: 45,
                                    height: 35.h,
                                  ),
                                )),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${booking.userData?.firstName} ${booking.userData?.lastName}",
                              style: latoBold.copyWith(
                                  fontSize: 14.sp,
                                  color: AppConfig.colors.secondaryThemeColor),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5.h),
                            Text(
                                "${DateFormat('hh:mm a').format(booking.bookingDate!.toDate())} - ${DateFormat.yMd().format(booking.bookingDate!.toDate())}",
                                style: latoRegular.copyWith(
                                    fontSize: 10.sp,
                                    color:
                                        AppConfig.colors.secondaryThemeColor)),
                            Text(booking.bookingAddress.address,
                                style: latoRegular.copyWith(
                                    fontSize: 10.sp,
                                    color:
                                        AppConfig.colors.secondaryThemeColor)),
                            SizedBox(height: 5.h),
                          ],
                        ),
                      ),
                      locationBtn(
                          booking, AppConfig.colors.themeColor, Colors.white),
                    ],
                  ));
            },
          ),
        ),
        SmoothPageIndicator(
          controller: _pageController,
          count: calenderProvider.selectedDayBookings.length,
          axisDirection: Axis.horizontal,
          effect: ExpandingDotsEffect(
            spacing: 8.0.sp,
            radius: 4.0.sp,
            dotWidth: 24.0.sp,
            dotHeight: 8.0.sp,
            dotColor: Colors.grey,
            activeDotColor: AppConfig.colors.themeColor,
          ),
        )
      ],
    );
  }

  /*=========================== Booking Location (Customer) ==========================*/

  Widget bookingLocation(AppProvider appProvider) {
    return (appProvider.selectedAddress != null)
        ? Container(
            margin: EdgeInsets.symmetric(vertical: 12.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0.sp),
                  child: Text(
                    "Booking Location",
                    style: latoBlack.copyWith(
                        fontSize: 16.sp,
                        color: AppConfig.colors.secondaryThemeColor),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    locationIcon(),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(appProvider.selectedAddress!.addressName,
                              style: latoBold.copyWith(
                                  fontSize: 14.sp,
                                  color: AppConfig.colors.secondaryThemeColor)),
                          Text("${appProvider.selectedAddress!.address}",
                              style: latoRegular.copyWith(
                                  fontSize: 12.sp,
                                  color: AppConfig.colors.secondaryThemeColor))
                        ],
                      ),
                    ),
                    changeBtn(),
                  ],
                ),
              ],
            ),
          )
        : GestureDetector(
            onTap: () async {
              appProvider.onTabAddNewAddress();
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                addressCardShimmer(),
                Column(
                  children: [
                    Text(
                      "To book any service you need to add at least one address",
                      style: latoBold.copyWith(
                        fontSize: 8.sp,
                        color: AppConfig.colors.secondaryThemeColor,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "Add address",
                      style: latoBold.copyWith(
                        fontSize: 12.sp,
                        color: AppConfig.colors.themeColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }

  Container locationIcon() {
    return Container(
        padding: EdgeInsets.all(6.sp),
        decoration: BoxDecoration(
          color: Color(0xffFDEEED),
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Image.asset(
          AppConfig.images.location,
          color: AppConfig.colors.themeColor,
          width: 18.w,
          height: 18.h,
        ));
  }

  Widget changeBtn() {
    return TextButton(
        onPressed: () {
          Get.to(SavedAddresses());
        },
        child: Text(
          "Change",
          style: latoBold.copyWith(
              fontSize: 12.sp, color: AppConfig.colors.themeColor),
        ));
  }

  Widget disableDateBtn(
      {required AuthProvider authProvider,
      required Timestamp date,
      required CalenderProvider calenderProvider}) {
    return GestureDetector(
      onTap: () async {
        bool check =
            await CustomDialog.showEnableDisableDialog(context, date.toDate());

        if (check) {
          DisableDates disableDateData;
          if (disableDate != null && disableDate!.isDisable == false) {
            disableDateData = DisableDates(
                id: disableDate!.id,
                disableDate: disableDate!.disableDate,
                isDisable: true,
                proId: disableDate!.proId);
          } else {
            disableDateData = DisableDates(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                disableDate: date,
                isDisable: true,
                proId: AppUser.user.email);
          }

          disableDate =
              await authProvider.disableOrEnableLDate(disableDateData);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                color: Color(0xffFDEEED),
                borderRadius: BorderRadius.circular(10.sp),
              ),
              child: Image.asset(AppConfig.images.disableDateIcon,
                  width: 14.w, height: 14.h)),
          SizedBox(height: 5.h),
          Text(
            "Disable",
            style: latoRegular.copyWith(
                fontSize: 8.sp, color: AppConfig.colors.secondaryThemeColor),
          )
        ],
      ),
    );
  }

  Widget enableDateBtn({required AuthProvider authProvider}) {
    return GestureDetector(
      onTap: () async {
        disableDate!.isDisable = false;

        disableDate = await authProvider.disableOrEnableLDate(disableDate!);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                color: Color(0xffF1FDED),
                borderRadius: BorderRadius.circular(10.sp),
              ),
              child: Image.asset(AppConfig.images.enableDateIcon,
                  width: 14.w, height: 14.h)),
          SizedBox(height: 5.h),
          Text(
            "Enable",
            style: latoRegular.copyWith(
                fontSize: 8.sp, color: AppConfig.colors.secondaryThemeColor),
          )
        ],
      ),
    );
  }
}
