
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/provider/authentication_provider.dart';


class FieldValidator {
  static String? validatePasswordSignup(String? value) {
    print("validatepassword : $value ");

    if (value!.isEmpty) {
      return "Enter Password";
    }
    return null;
  }

  static String? validateEmail(String ?value) {
    if (value!.isEmpty) {
      return "Email is Required";
      // return getTranslated(context, "email_is_req");
    }

    if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(value)) {
      return "Please enter a valid Email Address";
    }

    return null;
  }

  static String? validateConfirmPassword(String? value) {
    if (kDebugMode) {
      print("validatepassword : $value ");
    }

    if (value!.isEmpty) return "Confirm Password is Required";

    return null;
  }

  static String? validateFullName(String? value) {
    if (kDebugMode) {
      print("validateName : $value ");
    }

    if (value!.isEmpty) return "Enter  Name";
    if (value.length <= 2) {
      return " Name is too short";
    }
    if (value.length >= 100) {
      return "letters should be less than 100";
    }
    // Pattern pattern = r"^[a-zA-Z'\-\pL]+(?:(?! {2})[a-zA-Z'\-\pL ])*[a-zA-Z'\-\pL]+$";
    // Pattern pattern = r"^(?! )[A-Za-z\s]*$";

    // RegExp regex = new RegExp(pattern);
    // if (!regex.hasMatch(value.trim())) {
    //   return "Invalid  Name";
    // }

    return null;
  }
  static String? validateDescription(String? value) {
    if (kDebugMode) {
      print("validateName : $value ");
    }

    if (value!.isEmpty) return "Enter  Name";
    if (value.length <= 20) {
      return " Description is too short";
    }



    return null;
  }

  static String? validateField(String? value) {
    if (kDebugMode) {
      print("validateName : $value ");
    }

    if (value!.isEmpty) return "Field is empty";

    return null;
  }

  static String? validateConfirmPasswordSignup(String? value) {
    if (kDebugMode) {
      print("Confirm validate password : $value ");
    }

    if (value!.isEmpty) return "Enter Password";
    if (Provider.of<AuthProvider>(Get.context!, listen: false)
            .isAcceptedConfirmPWDProvider ==
        0) {
      return "Password doesn't match ";
    }
    return null;
  }
}
