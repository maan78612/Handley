import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:social_pro/constants/app_constants.dart';

class ShowMessage {


  static Widget errorGifWidget() {
    return Center(
        child: Image.asset(
          "assets/gifs/error_gif.gif",
          scale: 3,
        ));
  }

  static Widget noInternetWidget({double scale = 2}) {
    return Center(
        child: Image.asset(
          "assets/gifs/no_internet_gif.gif",
          scale: scale,
        ));
  }

  static Widget successWidget() {
    return Center(
        child: Image.asset(
          "assets/gifs/success_gif.gif",
          scale: 6,
        ));
  }

  static void toast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        fontSize: 14,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
  }

  static void snackBar(
      String title,
      String message,
      bool progress,
      ) {
    Get.snackbar(title, message,
        backgroundColor: AppConfig.colors.themeColor,
        colorText: Colors.white,
        showProgressIndicator: progress,
        progressIndicatorBackgroundColor: Colors.lightBlueAccent,
        progressIndicatorValueColor:
        const AlwaysStoppedAnimation<Color>(Colors.tealAccent),
        borderRadius: 6);
  }

  static void notifierSnackBar(String title, String message,
      {required SnackPosition position}) {
    Color contentColor = Colors.white;
    Get.snackbar(title, message,
        backgroundColor: AppConfig.colors.themeColor,
        colorText: contentColor,
        icon: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            Icons.info_outline_rounded,
            size: 50,
            color: contentColor,
          ),
        ),
        padding: EdgeInsets.fromLTRB(Get.width * 0.1, Get.height * 0.02,
            Get.width * 0.02, Get.height * 0.02),
        shouldIconPulse: false,
        maxWidth: Get.width,
        margin: EdgeInsets.zero,
        snackStyle: SnackStyle.GROUNDED,
        snackPosition: position,
        progressIndicatorBackgroundColor: Colors.lightBlueAccent,
        borderRadius: 8);
  }

  static void jsonToast(var jsonResponse) {
    Fluttertoast.showToast(
        msg: jsonResponse['ShortMessage'],
        fontSize: 16,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
  }

  static void inDialog(String message, bool isError) {
    Color color = isError ? Colors.redAccent : Colors.green;
    Get.defaultDialog(
        title: '',
        titleStyle: TextStyle(
            fontFamily: 'Monts',
            fontSize: Get.height * 0.0,
            fontWeight: FontWeight.bold),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: Get.height * 0.032,
              backgroundColor: color,
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: Get.height * 0.030,
                  child: Icon(
                    isError ? Icons.warning : Icons.done_outline,
                    color: color,
                    size: Get.height * 0.042,
                  )),
            ),
            SizedBox(
              height: Get.height * 0.016,
            ),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Monts', fontSize: Get.height * 0.022)),
            SizedBox(height: Get.height * 0.02),
          ],
        ),
        actions: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 16),
                  width: Get.width * .32,
                  height: Get.height * .05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppConfig.colors.themeColor),
                  child: Text(
                    'OK',
                    style: TextStyle(
                        fontFamily: 'Monts',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: Get.height * .024),
                  ),
                ),
              )
            ],
          )
        ]);
  }

  static void downloadingDialog(String message, bool isError, onPressed) {
    Color color = isError ? Colors.redAccent : Colors.green;
    Get.defaultDialog(
        title: '',
        titleStyle: TextStyle(
            fontFamily: 'Monts',
            fontSize: Get.height * 0.0,
            fontWeight: FontWeight.bold),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: Get.height * 0.032,
              backgroundColor: color,
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: Get.height * 0.030,
                  child: Icon(
                    isError ? Icons.warning : Icons.done_outline,
                    color: color,
                    size: Get.height * 0.042,
                  )),
            ),
            SizedBox(
              height: Get.height * 0.016,
            ),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Monts', fontSize: Get.height * 0.022)),
            SizedBox(height: Get.height * 0.02),
          ],
        ),
        actions: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              GestureDetector(
                onTap: onPressed,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 16),
                  width: Get.width * .32,
                  height: Get.height * .05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppConfig.colors.themeColor),
                  child: Text(
                    'OK',
                    style: TextStyle(
                        fontFamily: 'Monts',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: Get.height * .024),
                  ),
                ),
              )
            ],
          )
        ]);
  }

  static void inBottomSheet(
      {required String message, bool isError = false, required String buttonName}) {
    Get.bottomSheet(
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: Get.height * 0.02,
            ),
            isError ? errorGifWidget() : successWidget(),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Monts', fontSize: Get.height * 0.022)),
            SizedBox(height: Get.height * 0.05),
            GestureDetector(
              onTap: Get.back,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                width: Get.width * 0.8,
                height: Get.height * 0.06,
                margin: EdgeInsets.only(
                  top: Get.height * .015,
                  // bottom:
                  //     MediaQuery.of(context).size.height * .04,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppConfig.colors.themeColor,
                        AppConfig.colors.themeColor
                      ]),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff000000).withOpacity(0.16),
                      blurRadius: 5,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      "Ok",
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.04),
          ],
        ),
        backgroundColor: Colors.white,
        enableDrag: false,
        isDismissible: false);
  }

  static void ofNoInternetBottomSheet(String messgae, bool isError) {
    Get.bottomSheet(
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: Get.height * 0.02,
            ),
            ShowMessage.noInternetWidget(),
            Text(messgae,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Monts', fontSize: Get.height * 0.022)),
            SizedBox(height: Get.height * 0.05),
            GestureDetector(
              onTap: Get.back,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                width: Get.width * 0.8,
                height: Get.height * 0.06,
                margin: EdgeInsets.only(
                  top: Get.height * .015,
                  // bottom:
                  //     MediaQuery.of(context).size.height * .04,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppConfig.colors.themeColor,
                        AppConfig.colors.themeColor
                      ]),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff000000).withOpacity(0.16),
                      blurRadius: 5,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      "Retry",
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.04),
          ],
        ),
        backgroundColor: Colors.white,
        enableDrag: false,
        isDismissible: false);
    // Get.defaultDialog(
    //     title: '',
    //     titleStyle: TextStyle(
    //         fontFamily: 'Monts',
    //         fontSize: Get.height * 0.0,
    //         fontWeight: FontWeight.bold),
    //     content:
    //     actions: [
    //       Wrap(
    //         alignment: WrapAlignment.center,
    //         spacing: 8,
    //         runSpacing: 8,
    //         children: [
    //
    //         ],
    //       )
    //     ]);
  }

  static void ofSuccessInJson(
      var jsonResponse,
      /*Function onPressed*/
      ) {
    Get.bottomSheet(
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: Get.height * 0.02,
            ),
            ShowMessage.successWidget(),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Text(jsonResponse["ShortMessage"] ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Monts', fontSize: Get.height * 0.022)),
            SizedBox(height: Get.height * 0.05),
            GestureDetector(
              onTap: Get.back,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                width: Get.width * 0.8,
                height: Get.height * 0.06,
                margin: EdgeInsets.only(
                  top: Get.height * .015,
                  // bottom:
                  //     MediaQuery.of(context).size.height * .04,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppConfig.colors.themeColor,
                        AppConfig.colors.themeColor
                      ]),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff000000).withOpacity(0.16),
                      blurRadius: 5,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      "OK",
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.04),
          ],
        ),
        backgroundColor: Colors.white,
        enableDrag: false,
        isDismissible: false);
  }

  static void customDialog(String title, String message, String buttonName,
      Function onPressed, bool isError) {
    Color color = isError ? Colors.redAccent : Colors.green;
    Get.defaultDialog(
        title: '',
        titleStyle: TextStyle(
            fontFamily: 'Monts',
            fontSize: Get.height * 0.0,
            color: color,
            fontWeight: FontWeight.bold),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontFamily: 'Monts',
                  fontSize: Get.height * 0.03,
                  color: color,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: Get.height * 0.016,
            ),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Monts', fontSize: Get.height * 0.022)),
            SizedBox(height: Get.height * 0.02),
          ],
        ),
        actions: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              GestureDetector(
                onTap: () {

                    onPressed();

                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 16),
                  width: Get.width * .32,
                  height: Get.height * .05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppConfig.colors.themeColor),
                  child: Text(
                    buttonName,
                    style: TextStyle(
                        fontFamily: 'Monts',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: Get.height * .024),
                  ),
                ),
              )
            ],
          )
        ]);
  }

  static void customDialogOfJson(String title, var jsonResponse,
      String buttonName, Function onPressed, bool isError) {
    Color color = isError ? Colors.redAccent : Colors.green;
    Get.defaultDialog(
        title: title,
        titleStyle: TextStyle(
            fontFamily: 'Monts',
            fontSize: Get.height * 0.0,
            color: color,
            fontWeight: FontWeight.bold),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontFamily: 'Monts',
                  fontSize: Get.height * 0.03,
                  color: color,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: Get.height * 0.016,
            ),
            Text(jsonResponse['ShortMessage'] ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Monts', fontSize: Get.height * 0.022)),
            SizedBox(height: Get.height * 0.02),
          ],
        ),
        actions: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              GestureDetector(
                onTap: () {

                    onPressed();

                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 16),
                  width: Get.width * .32,
                  height: Get.height * .05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppConfig.colors.themeColor),
                  child: Text(
                    buttonName,
                    style: TextStyle(
                        fontFamily: 'Monts',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: Get.height * .024),
                  ),
                ),
              )
            ],
          )
        ]);
  }

  static void showSuccessSnackBar(var scaffoldKey, jsonResponse) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text(jsonResponse['ShortMessage'] ?? ""),
      duration: const Duration(seconds: 2),
    ));
  }

  static void showErrorSnackBar(var scaffoldKey, jsonResponse) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(jsonResponse['ShortMessage'] ?? ""),
      duration: const Duration(seconds: 2),
    ));
  }

  static void inSnackBar(var scaffoldKey, String message, bool isError) {
    Color color = isError ? Colors.red : Colors.green;
    scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: color,
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }
}
