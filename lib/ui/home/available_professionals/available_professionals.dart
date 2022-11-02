import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/model_classes/professions.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/provider/text_form_provider.dart';
import 'package:social_pro/ui/home/available_professionals/widgets/service_filter.dart';
import 'package:social_pro/ui/home/widgets/search_bar.dart';
import 'package:social_pro/ui/shared/customBottomSheet.dart';
import 'package:social_pro/ui/shared/professional_list.dart';

import '../../shared/empty_screen.dart';

class AvailableProfessionals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, TextFormProvider>(
        builder: (context, authProvider, textFormProvider, _) {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(left: 12.0.sp, right: 12.sp, top: 40.sp),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    searchAndFilterBar(authProvider),
                    if (authProvider.selectedFiltersList.isNotEmpty)
                      filteredServices(authProvider),
                    if (authProvider.selectedFiltersList.isEmpty)
                      SizedBox(height: 20.h),
                    changeDate(context: context, authProvider: authProvider),
                    ProfessionalsList(
                      professionals: authProvider.filterProfessionals,
                    ),
                  ]),
            ),
          ),
        ),
      );
    });
  }

  Widget changeDate(
      {required BuildContext context, required AuthProvider authProvider}) {
    return GestureDetector(
      onTap: () async {
        final datePick = await showDatePicker(
            context: context,
            initialDate: authProvider.selectedDateToFilterProfessionals,
            firstDate: DateTime.now(),
            lastDate: new DateTime(2200));
        if (datePick != null) {
          authProvider.selectDateForFilter(datePick);
        }
      },
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Professionals Available",
                style: latoBlack.copyWith(
                    fontSize: 16.sp,
                    color: AppConfig.colors.secondaryThemeColor)),
            Spacer(),
            calenderLogo(),
            SizedBox(width: 10.sp),
            Column(
              children: [
                Text("CHANGE DATE",
                    style: latoBold.copyWith(
                        fontSize: 10.sp, color: AppConfig.colors.themeColor)),
                SizedBox(height: 5.sp),
                Text(
                    DateFormat('EEEE, dd/MM/yyyy')
                        .format(authProvider.selectedDateToFilterProfessionals),
                    style: latoBlack.copyWith(
                        fontSize: 12.sp,
                        color: AppConfig.colors.secondaryThemeColor)),
              ],
            )
          ]),
    );
  }

  Widget calenderLogo() {
    return Container(
      width: 30.h,
      height: 30.h,
      decoration: BoxDecoration(
        color: const Color(0xffF5F4F4),
        borderRadius: BorderRadius.circular(10.sp),
      ),
      padding: EdgeInsets.all(6.sp),
      child: Image.asset(
        AppConfig.images.calendar,
        color: AppConfig.colors.themeColor,
        fit: BoxFit.contain,
      ),
    );
  }

  Column filteredServices(AuthProvider authProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0.sp),
          child: Text("Filters Selected",
              style: latoBlack.copyWith(
                  fontSize: 12.sp,
                  color: AppConfig.colors.secondaryThemeColor)),
        ),
        SizedBox(
          height: 45.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children:
                List.generate(authProvider.selectedFiltersList.length, (index) {
              Professions profession = authProvider.selectedFiltersList[index];
              return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.sp)),
                      border: Border.all(color: AppConfig.colors.themeColor),
                      color: AppConfig.colors.themeColor),
                  margin: EdgeInsets.all(8.sp),
                  alignment: Alignment.center,
                  width: 100.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${profession.title}",
                        textAlign: TextAlign.center,
                        style: latoBold.copyWith(
                          fontSize: 12.sp,
                          color: AppConfig.colors.whiteColor,
                        ),
                      ),
                      SizedBox(width: 15.sp),
                      GestureDetector(
                          onTap: () {
                            authProvider.removeServiceFilter(profession);
                          },
                          child: Icon(Icons.cancel_outlined,
                              size: 15.sp, color: AppConfig.colors.whiteColor))
                    ],
                  ));
            }),
          ),
        )
      ],
    );
  }

  Row searchAndFilterBar(AuthProvider authProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back)),
        SizedBox(width: 20.sp),
        Expanded(child: SearchBar()),
        SizedBox(width: 10.sp),
        GestureDetector(
          onTap: () async {
            CustomBottomSheet.customResponsiveBtmSheet(
                bottomSheet: ServiceFilter());
          },
          child: Container(
              decoration: BoxDecoration(
                color: authProvider.selectedFiltersList.isEmpty
                    ? Color(0xffF5F4F4)
                    : AppConfig.colors.themeColor,
                borderRadius: BorderRadius.circular(10.sp),
              ),
              padding: EdgeInsets.all(16.sp),
              width: 55.sp,
              height: 55.sp,
              child: Image.asset(
                AppConfig.images.filter,
                fit: BoxFit.contain,
                color: authProvider.selectedFiltersList.isEmpty
                    ? AppConfig.colors.secondaryThemeColor
                    : AppConfig.colors.whiteColor,
              )),
        ),
      ],
    );
  }
}
