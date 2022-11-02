import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/provider/text_form_provider.dart';
import 'package:social_pro/ui/home/widgets/professional_dialog_card.dart';

import 'empty_screen.dart';

class ProfessionalsList extends StatelessWidget {
  List<UserData> professionals;

  ProfessionalsList({Key? key, required this.professionals}) : super(key: key);
  double imageSize = 57.w;

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, TextFormProvider>(
        builder: (context, appProvider, textFormProvider, _) {
      return Padding(
        padding: EdgeInsets.all(8.0.sp),
        child: professionals.isEmpty
            ? Center(
                child: EmptyScreen(
                    image: AppConfig.images.warningIcon,
                    message: "No Professionals"),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(professionals.length, (index) {
                  UserData proData = professionals[index];
                  String name = proData.firstName + proData.lastName;
                  if (name
                      .toLowerCase()
                      .contains(textFormProvider.searchField)) {
                    return professionalCard(proData);
                  } else {
                    return SizedBox.shrink();
                  }
                }),
              ),
      );
    });
  }

  InkWell professionalCard(UserData proData) {
    return InkWell(
      onTap: () {
        Get.dialog(ProfessionalDialogCard(
          professionalUser: proData,
        ));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.centerLeft,
          children: [
            Container(
                padding:
                    EdgeInsets.symmetric(vertical: 16.0.sp, horizontal: 8.0.sp),
                margin: EdgeInsets.symmetric(horizontal: imageSize / 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.sp),
                    border: Border.all(color: const Color(0xffD9D4D5))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: imageSize),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${proData.firstName} ${proData.lastName}",
                            style: latoBold.copyWith(
                              fontSize: 14.sp,
                              color: AppConfig.colors.secondaryThemeColor,
                            ),
                          ),
                          Text(
                            proData.profession!.title,
                            style: latoBold.copyWith(
                              fontSize: 12.sp,
                              color: AppConfig.colors.secondaryThemeColor,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppConfig.colors.secondaryThemeColor,
                                ),
                              ),
                              Text(
                                '  ${proData.experience} years experience',
                                style: latoBold.copyWith(
                                    fontSize: 10.sp,
                                    color:
                                        AppConfig.colors.secondaryThemeColor),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppConfig.colors.secondaryThemeColor,
                                ),
                              ),
                              Text(
                                '  ${proData.satisfactionPercentage?.toInt()}% ',
                                style: latoBold.copyWith(
                                    fontSize: 10.sp,
                                    color:
                                        AppConfig.colors.secondaryThemeColor),
                              ),
                              Text(
                                'customer satisfaction',
                                style: latoBold.copyWith(
                                    fontSize: 10.sp,
                                    color:
                                        AppConfig.colors.secondaryThemeColor),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${proData.rating?.toStringAsFixed(1)}",
                              style: latoBold.copyWith(
                                  fontSize: 12.sp,
                                  color: AppConfig.colors.secondaryThemeColor),
                            ),
                            SizedBox(width: 5.w),
                            Icon(Icons.star, color: Colors.yellow, size: 16.sp),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Icon(
                          Icons.info_outline,
                          color: Color(0xff3A3335),
                          size: 18.sp,
                        ),
                      ],
                    )
                  ],
                )),
            Container(
                padding: EdgeInsets.all(4.sp),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.sp),
                    border: Border.all(color: AppConfig.colors.themeColor)),
                child: proData.imageUrl != ""
                    ? CachedNetworkImage(
                        imageUrl: proData.imageUrl,
                        fit: BoxFit.cover,
                        width: imageSize,
                        height: 50.h,
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.sp),
                        child: Image.asset(
                          AppConfig.images.account,
                          color: AppConfig.colors.themeColor,
                          fit: BoxFit.contain,
                          width: imageSize,
                          height: 30.h,
                        ),
                      )),
          ],
        ),
      ),
    );
  }
}
