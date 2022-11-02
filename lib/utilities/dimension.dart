import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Dimensions {
  static double fontSizeExtraSmall = 10.sp;
  static double fontSizeSmall =  12.sp;
  static double fontSizeDefault =  14.sp;
  static double fontSizeLarge = 16.sp;
  static double fontSizeExtraLarge =  18.sp;
  static double fontSizeOverLarge =  22.sp;

  static  double paddingExtraSmall = Get.context!.width >= 1300?2.5.w: 5.0.w;
  static  double paddingSmallSize = Get.context!.width >= 1300?5.w:10.0.w;
  static  double paddingSizeDefault = Get.context!.width >= 1300?7.w:13.0.w;
  static  double paddingSizeLarge = Get.context!.width >= 1300?10.w:20.0.w;
  static  double paddingSizeExtraLarge = Get.context!.width >= 1300?12.w:25.0.w;

  static  double radiusSmall =Get.context!.width >= 1300?1.w: 5.0.w;
  static  double radiusDefault = Get.context!.width >= 1300?2.w:10.0.w;
  static  double radiusLarge = Get.context!.width >= 1300?3.w:15.0..w;
  static  double radiusExtraLarge = Get.context!.width >= 1300?4.w:20.0.w;

  static  double webMaxWidth = 1170.w;
}


class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget windows;

  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.windows,
  }) : super(key: key);

// This size work fine on my design, maybe you need some customization depends on your design

  // This isMobile, isTablet, isDesktop helep us later
  static bool isMobile() =>
      MediaQuery.of(Get.context!).size.width < 850;

  static bool isTablet() =>
      MediaQuery.of(Get.context!).size.width < 1300 &&
          MediaQuery.of(Get.context!).size.width >= 850;

  static bool isDesktop() =>
      MediaQuery.of(Get.context!).size.width >= 1300;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    // If our width is more than 1100 then we consider it a desktop
    if (_size.width >= 1100) {
      return windows;
    }
    // If width it less then 1100 and more then 850 we consider it as tablet
    else if (_size.width >= 850 && tablet != null) {
      return tablet!;
    }
    // Or less then that we called it mobile
    else {
      return mobile;
    }
  }
}