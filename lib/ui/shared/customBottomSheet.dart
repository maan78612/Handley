import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_pro/model_classes/user_data.dart';

class CustomBottomSheet {
  static dynamic customResponsiveBtmSheet({required Widget bottomSheet}) async {
    await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: Get.context!,
        isScrollControlled: true,
        isDismissible: false,
        builder: (BuildContext context) {
          return bottomSheet;
        });
  }
}

