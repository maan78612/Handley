import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/ui/auth/sign_up_view.dart';
import 'package:social_pro/ui/auth/widget/forget_password.dart';
import 'package:social_pro/ui/shared/app_button.dart';
import 'package:social_pro/ui/shared/custom_loader.dart';
import 'package:social_pro/ui/shared/custom_text_field.dart';
import 'package:social_pro/utilities/app_utility.dart';
import 'package:social_pro/utilities/dimension.dart';

import 'package:get/get.dart';
import 'package:social_pro/utilities/validator.dart';

class SignInView extends StatefulWidget {
  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final GlobalKey<FormState> signInFromKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, auth, _) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: WillPopScope(
          onWillPop: AppUtility().onWillPop,
          child: Scaffold(
            backgroundColor: AppConfig.colors.whiteColor,
            // appBar: authAppBar(),
            body: ModalProgressHUD(
              inAsyncCall: auth.isLoading,
              progressIndicator: customLoader(),
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 30.h),
                      Center(
                        child: Image.asset(
                          AppConfig.images.logo,
                          height: 250.h,
                        ),
                      ),
                      loginCard(auth),
                      socialLogin(),
                      signUpText(auth),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Column socialLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            const Expanded(
                child: Divider(
              color: Color(0xffD9D4D5),
              thickness: 1,
              indent: 20,
              endIndent: 10,
            )),
            Text(
              "OR",
              style: latoBlack.copyWith(
                  fontSize: 12.sp, color: AppConfig.colors.themeColor),
            ),
            const Expanded(
                child: Divider(
              color: Color(0xffD9D4D5),
              thickness: 1,
              indent: 10,
              endIndent: 20,
            )),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Login with",
            style: latoRegular.copyWith(
                fontSize: 12.sp, color: AppConfig.colors.secondaryThemeColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 37.h,
                height: 38.h,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xff3A3335))),
                child: Image.asset(AppConfig.images.fbLogo),
              ),
              SizedBox(width: 20.w),
              Container(
                width: 37.h,
                height: 38.h,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xff3A3335))),
                child: Image.asset(AppConfig.images.googleLogo),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget loginCard(AuthProvider auth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: Dimensions.paddingSizeDefault,
              right: Dimensions.paddingSizeDefault,
            ),
            child: Text(
              "Login",
              style: latoBlack.copyWith(
                  fontSize: 24.sp, color: AppConfig.colors.secondaryThemeColor),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Form(
            key: signInFromKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: [
                GlobalFormField(

                  hint: "Enter your email",
                  title: "Email",
                  titleColor: AppConfig.colors.fieldTitleColor,
                  controller: auth.loginEmailController,
                  focusNode: auth.loginEmailFocusNode,
                  nextNode: auth.loginPassFocusNode,
                  type: TextInputType.text,
                  action: TextInputAction.next,
                  textLimit: 50,
                  validator: FieldValidator.validateEmail,
                  isPassword: false,
                  isEmail: true,
                  prefixIcon: null,
                ),
                GlobalFormField(

                  hint: "Enter your password",
                  title: "Password",
                  titleColor: AppConfig.colors.fieldTitleColor,
                  prefixIcon: null,
                  controller: auth.loginPassController,
                  focusNode: auth.loginPassFocusNode,
                  type: TextInputType.text,
                  action: TextInputAction.done,
                  textLimit: 25,
                  validator: FieldValidator.validatePasswordSignup,
                  isPassword: true,
                  nextNode: FocusNode(),
                  isEmail: false,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.bottomSheet(ForgotPasswordDialog());
            },
            child: Padding(
              padding: EdgeInsets.only(
                  right: Dimensions.paddingExtraSmall,
                  top: Dimensions.paddingExtraSmall,
                  bottom: Dimensions.paddingExtraSmall),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Forgot Password?",
                    style: latoRegular.copyWith(
                        fontSize: 12.sp, color: AppConfig.colors.themeColor),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Dimensions.paddingSmallSize),
            child: appButton(
                btnColor: AppConfig.colors.themeColor,
                textColor: AppConfig.colors.whiteColor,
                title: "LOGIN",
                onTab: () {
                  if (signInFromKey.currentState!.validate()) {
                    auth.loginUser();
                  }
                },
                isIcon: false),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget signUpText(AuthProvider auth) {
    return Column(
      children: [
        Text(
          "Don't have an account?",
          style: latoRegular.copyWith(
              fontSize: 12.sp, color: AppConfig.colors.secondaryThemeColor),
        ),
        InkWell(
          onTap: () {
            auth.userImage = null;
            auth.clearSignInData();
            Get.off(SignUpView());
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "Sign Up",
              style: latoBlack.copyWith(
                  fontSize: 12.sp, color: AppConfig.colors.themeColor),
            ),
          ),
        ),
      ],
    );
  }
}
