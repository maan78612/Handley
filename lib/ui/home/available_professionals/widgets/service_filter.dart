import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/model_classes/professions.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/ui/shared/app_button.dart';

class ServiceFilter extends StatefulWidget {
  @override
  _ServiceFilterState createState() => _ServiceFilterState();
}

class _ServiceFilterState extends State<ServiceFilter>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  List<Professions> selectedProfessions = [];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.ease);
    selectedProfessions.addAll(
        Provider.of<AuthProvider>(context, listen: false).selectedFiltersList);
    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      return SingleChildScrollView(
          child: Container(
        alignment: Alignment.topCenter,
        decoration: ShapeDecoration(
          color: AppConfig.colors.whiteColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(17),
              topRight: Radius.circular(17),
            ),
          ),
        ),
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 16.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        authProvider.applyFilterInitially();
                        Get.back();
                      },
                      child: Text("Reset",
                          style: latoRegular.copyWith(
                              fontSize: 14.sp,
                              color: AppConfig.colors.themeColor)),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Filters",
                            style: latoBlack.copyWith(
                                fontSize: 14.sp,
                                color: AppConfig.colors.secondaryThemeColor)),
                      ),
                    ),
                    SizedBox(width: 10.sp),
                    GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.cancel_outlined)),
                  ],
                ),
                SizedBox(height: 10.h),
                Text("Services",
                    style: latoBlack.copyWith(
                        fontSize: 14.sp,
                        color: AppConfig.colors.secondaryThemeColor)),
                SizedBox(height: 10.h),
                Wrap(
                  children: List.generate(authProvider.professionList.length,
                      (index) {
                    Professions profession = authProvider.professionList[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedProfessions.contains(profession)) {
                            selectedProfessions.remove(profession);
                          } else {
                            selectedProfessions.add(profession);

                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.sp)),
                            border:
                                Border.all(color: AppConfig.colors.themeColor),
                            color: selectedProfessions.contains(profession)
                                ? AppConfig.colors.themeColor
                                : AppConfig.colors.whiteColor),
                        margin: EdgeInsets.all(8.sp),
                        alignment: Alignment.center,
                        width: 100.w,
                        height: 35.h,
                        child: Text(
                          "${profession.title}",
                          textAlign: TextAlign.center,
                          style: latoBold.copyWith(
                              fontSize: 12.sp,
                              color: selectedProfessions.contains(profession)
                                  ? AppConfig.colors.whiteColor
                                  : AppConfig.colors.secondaryThemeColor),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 20.h),
                appButton(
                    title: "APPLY",
                    textColor: AppConfig.colors.whiteColor,
                    isIcon: false,
                    btnColor: AppConfig.colors.themeColor,
                    onTab: () {

                        authProvider.applyFilter(selectedProfessions);


                      Get.back();
                    }),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ));
    });
  }
}
