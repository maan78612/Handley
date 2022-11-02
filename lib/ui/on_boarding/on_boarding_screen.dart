import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_pro/Hive/hive_services.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/ui/auth/sign_in_view.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController _pageController = PageController();
  int currentIndex = 0;
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.colors.whiteColor,
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: PageView(
              controller: _pageController,
              onPageChanged: onChangedFunction,
              children: [
                onBoardingPage(
                  index: 0,
                  description:
                      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod.",
                  title: "Getting Started 1",
                ),
                onBoardingPage(
                  index: 0,
                  description:
                      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod.",
                  title: "Getting Started 2",
                ),
                onBoardingPage(
                  index: 0,
                  description:
                      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod.",
                  title: "Getting Started 3",
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  if (currentIndex != 0) backBtn(),
                  SizedBox(
                    width: 20.w,
                  ),
                  forwardBtn(),
                ],
              ),
            ),
          ),
          const Spacer(),
          // SizedBox(height: 70.h),
        ],
      ),
    );
  }

  InkWell forwardBtn() {
    return InkWell(
      onTap: () async {
        if (currentIndex == 2) {
          await HiveServices.insertString(HiveServices.onBoardingKey, "true");
          Get.offAll(SignInView());
        } else {
          nextFunction();
        }
      },
      child: Container(
        width: 75.w,
        height: 76.h,
        padding: EdgeInsets.all(8.0.sp),
        decoration: BoxDecoration(
          color: AppConfig.colors.themeColor,
          borderRadius: BorderRadius.circular(20.sp),
        ),
        child: Icon(
          currentIndex != 2 ? Icons.arrow_forward_outlined : Icons.done,
          color: AppConfig.colors.whiteColor,
          size: 35.sp,
        ),
      ),
    );
  }

  InkWell backBtn() {
    return InkWell(
      onTap: () => previousFunction(),
      child: Container(
        width: 53.w,
        height: 54.h,
        padding: EdgeInsets.all(8.0.sp),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.sp),
            border: Border.all(color: const Color(0xff3A3335))),
        child: const Icon(Icons.arrow_back_outlined),
      ),
    );
  }

  Widget onBoardingPage(
      {required String title,
      required String description,
      required int index}) {
    return Stack(
      children: [
        if (currentIndex != 2)
          Positioned(top: 50.h, right: 20.w, child: skipBtn()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 120.h),
              Center(
                child: Image.asset(
                  AppConfig.images.logo,
                  height: 288.h,
                ),
              ),
              SizedBox(height: 50.h),
              Text(
                title,
                style: latoBlack.copyWith(
                    fontSize: 24.sp,
                    color: AppConfig.colors.secondaryThemeColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  description,
                  textAlign: TextAlign.left,
                  style: latoRegular.copyWith(
                      fontSize: 18.sp,
                      color: AppConfig.colors.secondaryThemeColor),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                  children: List.generate(3, (index) {
                return Container(
                  width: 43.w,
                  height: 9.h,
                  margin: EdgeInsets.only(right: 8.w),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: index == currentIndex
                        ? AppConfig.colors.themeColor
                        : AppConfig.colors.themeColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }))
            ],
          ),
        )
      ],
    );
  }

  InkWell skipBtn() {
    return InkWell(
      onTap: () async {
        await HiveServices.insertString(HiveServices.onBoardingKey, "true");
        Get.offAll(SignInView());
      },
      child: Container(
        height: 32.h,
        width: 75.w,
        alignment: Alignment.center,
        padding:  EdgeInsets.all(8.0.sp),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.sp),
            border: Border.all(color: const Color(0xff3A3335))),
        child: Text(
          "SKIP",
          style: latoBold.copyWith(
              fontSize: 12.sp, color: AppConfig.colors.secondaryThemeColor),
        ),
      ),
    );
  }

  nextFunction() {
    _pageController.nextPage(duration: _kDuration, curve: _kCurve);
  }

  previousFunction() {
    _pageController.previousPage(duration: _kDuration, curve: _kCurve);
  }

  onChangedFunction(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
