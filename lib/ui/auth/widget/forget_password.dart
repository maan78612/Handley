import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/ui/shared/app_button.dart';
import 'package:social_pro/ui/shared/custom_loader.dart';
import 'package:social_pro/utilities/dimension.dart';
import 'package:social_pro/utilities/validator.dart';


class ForgotPasswordDialog extends StatefulWidget {
  @override
  _ForgotPasswordDialogState createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailCon = new TextEditingController();
  FocusNode emailFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      return ModalProgressHUD(
        inAsyncCall: authProvider.isLoading,
        progressIndicator: customLoader(),
        child: SingleChildScrollView(
          child: Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: Get.height * 0.01),
                  width: Get.width * .17,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Get.height * .02,
                      ),
                      Text('Forgot Password',
                          style: latoBold.copyWith(
                              fontSize: 16.sp,
                              color: AppConfig.colors.secondaryThemeColor)),
                      SizedBox(height: 20.h),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width * .06),
                        child: Text(
                          "Please enter your email to receive password reset link.",
                          style: latoRegular.copyWith(
                              fontSize: 14.sp,
                              color: AppConfig.colors.secondaryThemeColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 4),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Email',
                                style: latoRegular.copyWith(
                                    fontSize: 18.sp,
                                    color:
                                        AppConfig.colors.secondaryThemeColor),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            _textFormFiled()
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      authProvider.isLoading
                          ? customLoader()
                          : appButton(
                              title: 'PROCEED',
                              isIcon: false,
                              btnColor: AppConfig.colors.themeColor,
                              textColor: AppConfig.colors.whiteColor,
                              onTab: () {
                                if (formKey.currentState!.validate()) {
                                  Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .forgotPassword(emailCon.text);
                                }
                              }),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _textFormFiled() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h, top: 10.h),
      child: TextFormField(
        controller: emailCon,
        focusNode: emailFocusNode,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          isDense: true,
          hintText: "Enter your email",
          fillColor: emailFocusNode.hasFocus
              ? AppConfig.colors.whiteColor
              : AppConfig.colors.fillColor,
          filled: true,
          hintStyle:
              TextStyle(fontSize: 14.sp, color: AppConfig.colors.hintColor),
          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
            borderSide: BorderSide(color: AppConfig.colors.fieldBorderColor),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
            borderSide: BorderSide(color: AppConfig.colors.fieldBorderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
            borderSide: BorderSide(color: AppConfig.colors.enableBorderColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
            borderSide: BorderSide(color: AppConfig.colors.fieldBorderColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: AppConfig.colors.fieldBorderColor),
          ),
        ),
        cursorColor: Colors.black,
        textAlign: TextAlign.left,
        onTap: () {
          setState(() {});
        },
        validator: FieldValidator.validateEmail,
        onFieldSubmitted: (value) {},
      ),
    );
  }
}
