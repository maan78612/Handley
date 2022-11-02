import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/provider/text_form_provider.dart';



class CustomersList extends StatelessWidget {
  List<UserData> professionals;

  CustomersList({Key? key, required this.professionals}) : super(key: key);
  double imageSize = 57.w;

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, TextFormProvider>(
        builder: (context, appProvider, textFormProvider, _) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(professionals.length, (index) {
            UserData customerData = professionals[index];
            String name = customerData.firstName + customerData.lastName;
            if (name.toLowerCase().contains(textFormProvider.searchField)) {
              return customerCard(customerData, appProvider);
            } else {
              return SizedBox.shrink();
            }
          }),
        ),
      );
    });
  }

  InkWell customerCard(UserData customerData, AppProvider appProvider) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.centerLeft,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 100.h,
              ),
              child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 16.0.sp, horizontal: 8.0.sp),
                  margin: EdgeInsets.symmetric(horizontal: imageSize / 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.sp),
                      border: Border.all(color: const Color(0xffD9D4D5))),
                  child: Padding(
                    padding: EdgeInsets.only(left: imageSize),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${customerData.firstName} ${customerData.lastName}",
                            style: latoBold.copyWith(
                              fontSize: 14.sp,
                              color: AppConfig.colors.secondaryThemeColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            appProvider.startChat(customerData.email);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.sp, vertical: 8.sp),
                            decoration: BoxDecoration(
                                color: AppConfig.colors.themeColor,
                                borderRadius: BorderRadius.circular(12.sp),
                                border: Border.all(
                                    color: AppConfig.colors.themeColor)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppConfig.images.chat,
                                  fit: BoxFit.contain,
                                  width: 17.w,
                                  height: 17.h,
                                  color: AppConfig.colors.whiteColor,
                                ),
                                Text(
                                  'Chat',
                                  style: latoBold.copyWith(
                                      fontSize: 12.sp,
                                      color: AppConfig.colors.whiteColor),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            Container(
                padding: EdgeInsets.all(4.sp),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.sp),
                    border: Border.all(color: AppConfig.colors.themeColor)),
                child: customerData.imageUrl != ""
                    ? CachedNetworkImage(
                        imageUrl: customerData.imageUrl,
                        fit: BoxFit.cover,
                        width: imageSize,
                        height: 57.h,
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
