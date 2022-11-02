import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_pro/constants/app_constants.dart';

class addressCardShimmer extends StatelessWidget {
  const addressCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: bookingLocation(),
      enabled: true,
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[50]!,
    );
  }

  Container bookingLocation() {
    return Container(

      child: Row(
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
                SizedBox(height: 10),
                Container(
                  width: 80.sp,
                  height: 10.sp,
                  color: Colors.white,
                ),
                Container(
                  margin: EdgeInsets.only(top: 7.sp),
                  width: 200.sp,
                  height: 6.sp,
                  color: Colors.white,
                ),
                Container(
                  margin: EdgeInsets.only(top: 2.sp),
                  width: 100.sp,
                  height: 6.sp,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 7.sp),
            width: 40.sp,
            height: 10.sp,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Container locationIcon() {
    return Container(
        padding: EdgeInsets.all(6.sp),
        decoration: BoxDecoration(
          color: Color(0xff3A3335).withOpacity(0.5),
          borderRadius: BorderRadius.circular(20.sp),
        ),
        child: Image.asset(
          AppConfig.images.location,
          color: Color(0xff3A3335),
          width: 18.w,
          height: 18.h,
        ));
  }


}
