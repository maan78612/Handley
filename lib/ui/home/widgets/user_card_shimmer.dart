import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shimmer/shimmer.dart';


import '../../../constants/app_constants.dart';
import '../../../constants/styles.dart';

class UserCardShimmer extends StatelessWidget {
  const UserCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Shimmer.fromColors(
            child: userShimmerCard(),
            enabled: true,
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
          ),
        ),
        Expanded(
          flex: 1,
          child: Shimmer.fromColors(
            child: userShimmerCard(),
            enabled: true,
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
          ),
        ),
      ],
    );
  }



  Widget userShimmerCard() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.centerLeft,
      children: [
        Container(
            padding: EdgeInsets.all(12.0.sp),
            margin: EdgeInsets.symmetric(horizontal: 25.sp / 2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.sp),
                border: Border.all(color: const Color(0xffD9D4D5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60.sp,
                      height: 8.sp,
                      color: Colors.white,
                    ),
                    Container(
                      width: 60.sp,
                      height: 6.sp,
                      margin: EdgeInsets.only(top: 5.sp),
                      color: Colors.white,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 10.sp,
                          height: 8.sp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5.w),
                        Icon(Icons.star, color: Colors.white, size: 16.sp),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.info_outline,
                  color: Color(0xff3A3335),
                  size: 16.sp,
                )
              ],
            )),
        Container(
          padding: EdgeInsets.all(4.sp),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppConfig.colors.themeColor)),
          child: Container(
            width: 40.sp,
            height: 40.sp.sp,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

