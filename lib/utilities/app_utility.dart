import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_pro/utilities/show_message.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUtility {
  static Transition pageTransition = Transition.leftToRightWithFade;
  static Duration transitionDuration = const Duration(milliseconds: 1000);
  static String msgErrorTitle = "Uh Oh!";
  static String msgSuccessTitle = "Success";
  static String myFcmToken = "";
  static String paymentTrxId = "", freshFCM = "";

  static void hideKeyboard() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }

  static String getFreshTimeStamp() {
    return Timestamp.now().millisecondsSinceEpoch.toString();
  }

  // will pop function
  late DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ShowMessage.toast("press again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }






}
