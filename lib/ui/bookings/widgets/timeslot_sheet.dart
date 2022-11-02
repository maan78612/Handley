import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/provider/calender_provider.dart';
import 'package:social_pro/utilities/enums.dart';

class TimeSlot extends StatelessWidget {
  String customerID;
  String proID;

  TimeSlot({Key? key, required this.proID, required this.customerID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, CalenderProvider>(
        builder: (context, appProvider, calenderProvider, _) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppUser.user.userType == UserType.customer
                      ? "Booking Time Slots"
                      : "Booked Time Slots",
                  style: latoBlack.copyWith(
                      fontSize: 16.sp,
                      color: AppConfig.colors.secondaryThemeColor),
                ),
           if(AppUser.user.userType == UserType.customer)     Text(
                  DateFormat.yMd().format(calenderProvider.selectedDate),
                  style: latoRegular.copyWith(
                      fontSize: 14.sp, color: AppConfig.colors.themeColor),
                ),
              ],
            ),
          ),
          Text(
            "Greyed out buttons mean the professional is unavailable at that time.",
            style: latoRegular.copyWith(
                fontSize: 12.sp,
                color: AppConfig.colors.secondaryThemeColor.withOpacity(0.6)),
          ),
          Align(
            alignment: Alignment.center,
            child: Wrap(
              alignment: WrapAlignment.center,
              children:
                  List.generate(calenderProvider.timeSlots.length, (index) {
                return Padding(
                  padding: EdgeInsets.all(6.sp),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.sp),
                                side: BorderSide(
                                    color: calenderProvider.bookedTime.contains(
                                            calenderProvider.timeSlots[index])
                                        ? AppConfig.colors.blackGrey
                                        : AppConfig.colors.themeColor))),
                        backgroundColor: MaterialStateProperty.all(
                            calenderProvider.selectDateTmeSlot ==
                                    calenderProvider.timeSlots[index]
                                ? AppConfig.colors.themeColor
                                : AppConfig.colors.whiteColor)),
                    onPressed: !calenderProvider.bookedTime
                            .contains(calenderProvider.timeSlots[index])
                        ? () {
                            if (AppUser.user.userType != UserType.professional)
                              calenderProvider.selectDateFromTimeSlot(
                                  calenderProvider.timeSlots[index]);
                          }
                        : null,
                    child: Container(
                      width: 70.sp,
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        calenderProvider
                            .formattedDate(calenderProvider.timeSlots[index]),
                        style: latoBold.copyWith(
                          fontSize: 12.sp,
                          color: calenderProvider.selectDateTmeSlot ==
                                  calenderProvider.timeSlots[index]
                              ? AppConfig.colors.whiteColor
                              : calenderProvider.bookedTime.contains(
                                      calenderProvider.timeSlots[index])
                                  ? Colors.grey
                                  : AppConfig.colors.secondaryThemeColor,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      );
    });
  }
}
