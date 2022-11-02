import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/model_classes/booking_model.dart';



Widget locationBtn( BookingModel bookingData,Color backGround,Color iconClr) {
  return GestureDetector(
    onTap: () async {
      Coords cords= Coords(bookingData.bookingAddress.location.lat, bookingData.bookingAddress.location.long);
      if (Platform.isIOS) {
        await MapLauncher.showMarker(
          mapType: MapType.apple,
          coords: cords,
          title: "Booking for ${bookingData.userData?.firstName}",

        );
      } else {
        await MapLauncher.showMarker(
          mapType: MapType.google,
          coords: cords,
          title: "Shanghai Tower",

        );
      }
    },
    child: Container(
        padding: EdgeInsets.all(6.sp),

        decoration: BoxDecoration(
          color: backGround,
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Image.asset(
          AppConfig.images.location,
          color: iconClr,
          width: 18.w,
          height: 18.h,
        )),
  );
}
