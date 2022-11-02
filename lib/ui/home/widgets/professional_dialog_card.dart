import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/model_classes/booking_model.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/provider/text_form_provider.dart';
import 'package:social_pro/ui/bookings/booking_details.dart';
import 'package:social_pro/ui/shared/custom_loader.dart';


class ProfessionalDialogCard extends StatelessWidget {
  UserData professionalUser;

  ProfessionalDialogCard({Key? key, required this.professionalUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            color: AppConfig.colors.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: EdgeInsets.symmetric(horizontal: 16.sp),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp),
                  Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(Icons.cancel_outlined))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                            padding: EdgeInsets.all(8.sp),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: AppConfig.colors.themeColor)),
                            child: professionalUser.imageUrl != ""
                                ? CachedNetworkImage(
                                    imageUrl: professionalUser.imageUrl,
                                    fit: BoxFit.cover,
                                    height: 83.h,
                                  )
                                : Image.asset(
                                    AppConfig.images.account,
                                    color: AppConfig.colors.themeColor,
                                    fit: BoxFit.contain,
                                    height: 83.h,
                                  )),
                      ),
                      SizedBox(width: 25.w),
                      Expanded(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${professionalUser.firstName} ${professionalUser.lastName}",
                              style: latoRegular.copyWith(
                                  fontSize: 24.sp,
                                  color: AppConfig.colors.secondaryThemeColor),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              professionalUser.profession?.title ?? "",
                              style: latoBold.copyWith(
                                fontSize: 14.sp,
                                color: AppConfig.colors.secondaryThemeColor,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "${professionalUser.rating?.toStringAsFixed(1)}",
                                  style: latoBold.copyWith(
                                      fontSize: 16.sp,
                                      color:
                                          AppConfig.colors.secondaryThemeColor),
                                ),
                                SizedBox(width: 5.w),
                                const Icon(Icons.star,
                                    color: Color(0xffE6C65C), size: 18),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          color: Color(0xffFDEEED),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.sp, vertical: 8.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppConfig.images.experience,
                                  fit: BoxFit.contain,
                                  width: 15.w,
                                  height: 15.h,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  '${professionalUser.experience} years experience',
                                  style: latoBold.copyWith(
                                      fontSize: 10.sp,
                                      color:
                                          AppConfig.colors.secondaryThemeColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          color: Color(0xffFDEEED),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.sp, vertical: 8.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppConfig.images.satisfaction,
                                  fit: BoxFit.contain,
                                  width: 15.w,
                                  height: 15.h,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  '${professionalUser.satisfactionPercentage?.toInt()}% customer satisfaction',
                                  style: latoBold.copyWith(
                                      fontSize: 10.sp,
                                      color:
                                          AppConfig.colors.secondaryThemeColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                  SizedBox(height: 10.h),
                  Text(
                    "Description",
                    style: latoBold.copyWith(
                      fontSize: 16.sp,
                      color: AppConfig.colors.secondaryThemeColor,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    professionalUser.description ?? "",
                    style: latoRegular.copyWith(
                      fontSize: 12,
                      color: AppConfig.colors.secondaryThemeColor,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  appProvider.isLoading
                      ? Center(child: customLoader())
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () async {
                                  appProvider.startChat(professionalUser.email);
                                 Get.back();
                                },
                                child: Container(
                                  height: 53.h,
                                  padding: EdgeInsets.all(2.sp),
                                  margin: EdgeInsets.all(8.sp),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: AppConfig.colors.themeColor)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AppConfig.images.chat,
                                        fit: BoxFit.contain,
                                        width: 25.w,
                                        height: 25.h,
                                      ),
                                      Text(
                                        'Chat',
                                        style: latoBold.copyWith(
                                            fontSize: 12.sp,
                                            color: AppConfig
                                                .colors.secondaryThemeColor),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: GestureDetector(
                                onTap: () async {
                                  print(appProvider.isLoading);
                                  List<BookingModel> bookingsOfProfessional =
                                      await appProvider
                                          .fetchBookingOfProfessional(
                                              professionalUser.email);
                                  Get.back();
                                  Provider.of<TextFormProvider>(context,
                                          listen: false)
                                      .clearSearchText();
                                  Get.to(BookingDetails(
                                    bookingList: bookingsOfProfessional,
                                    professionalUser: professionalUser,
                                  ));
                                },
                                child: Container(
                                  height: 53.h,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(8.sp),
                                  margin: EdgeInsets.all(8.sp),
                                  decoration: BoxDecoration(
                                      color: AppConfig.colors.themeColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: AppConfig.colors.themeColor)),
                                  child: Text(
                                    'BOOK',
                                    style: latoBlack.copyWith(
                                        fontSize: 18.sp,
                                        color: AppConfig.colors.whiteColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  SizedBox(height: Get.height * 0.015),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
