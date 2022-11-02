import 'dart:io';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/ui/auth/sign_in_view.dart';
import 'package:social_pro/ui/auth/widget/auth_appBar.dart';
import 'package:social_pro/ui/auth/widget/documnet_viewer_sign_up.dart';
import 'package:social_pro/ui/auth/widget/drop_down_field.dart';
import 'package:social_pro/ui/shared/app_button.dart';
import 'package:social_pro/ui/shared/custom_loader.dart';
import 'package:social_pro/ui/shared/custom_text_field.dart';
import 'package:social_pro/utilities/app_utility.dart';
import 'package:social_pro/utilities/dimension.dart';
import 'package:social_pro/utilities/enums.dart';
import 'package:social_pro/utilities/show_message.dart';
import 'package:social_pro/utilities/validator.dart';


class SignUpView extends StatefulWidget {
  @override
  SignUpViewState createState() => SignUpViewState();
}

class SignUpViewState extends State<SignUpView> {
  final signUpFormKey = GlobalKey<FormState>();
  final professionalFormKey = GlobalKey<FormState>();

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
            appBar: authAppBar(onTab: () {
              auth.clearSignUpData();
              Get.off(SignInView());
            }),
            body: ModalProgressHUD(
              inAsyncCall: auth.isLoading,
              progressIndicator: customLoader(),
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: signUpCard(auth),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget signUpCard(AuthProvider authProvider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
              authProvider.isProfessional ? "Professional Sign Up" : "Sign Up",
              style: latoBlack.copyWith(
                  fontSize: 24.sp, color: AppConfig.colors.secondaryThemeColor),
            ),
          ),
          SizedBox(height: 15.h),
          // TopImageCard(isProfile: false),
          authProvider.isProfessional
              ? professionalForm(authProvider)
              : signUpForm(authProvider),
          SizedBox(height: 15.h),
          if (!authProvider.isProfessional) _termsConditions(authProvider),
          SizedBox(height: 15.h),
          appButton(
              btnColor: AppConfig.colors.themeColor,
              textColor: AppConfig.colors.whiteColor,
              title: authProvider.isProfessional ? "SUBMIT" : "SIGN UP",
              onTab: () async {
                /* if professional submit all data*/
                if (authProvider.isProfessional) {
                  if (professionalFormKey.currentState!.validate()) {
                    await authProvider.registerUser(authProvider.isProfessional
                        ? UserType.professional
                        : UserType.customer);
                  }
                } else {
                  /* if customer give option to register as customer or extra add details for professional */
                  if (signUpFormKey.currentState!.validate()) {
                    authProvider.matchPassProvider(
                        authProvider.passwordController.value.text.toString());

                    if (authProvider.passwordController.value.text.toString() !=
                        authProvider.confirmPasswordController.value.text
                            .toString()) {
                      Fluttertoast.showToast(
                          msg: 'Password does not match',
                          backgroundColor: Colors.red);
                    } else if (authProvider.selectTerms == false) {
                      Fluttertoast.showToast(
                          msg: 'Please accept the terms & conditions');
                    } else {
                      Get.bottomSheet(
                          signUpRoleConfirmationBottomSheet(authProvider));
                      // await registerUser(userType);
                    }
                  }
                }
              },
              isIcon: false),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Container signUpRoleConfirmationBottomSheet(AuthProvider authProvider) {
    return Container(
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
          color: AppConfig.colors.whiteColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimensions.radiusDefault),
              topRight: Radius.circular(Dimensions.radiusDefault))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "One last thing…",
            style: latoBold.copyWith(
                fontSize: 34.sp, color: AppConfig.colors.secondaryThemeColor),
          ),
          SizedBox(height: 40.h),
          Text(
            "Are you a professional and want to continue as a professional on the platform?",
            style: latoRegular.copyWith(
                fontSize: 21.sp, color: AppConfig.colors.secondaryThemeColor),
          ),
          SizedBox(height: 20.h),
          Text(
            "Additional information is required if yes.",
            style: latoBold.copyWith(
                fontSize: 12.sp,
                fontStyle: FontStyle.italic,
                color: const Color(0xffD9D4D5)),
          ),
          SizedBox(height: 40.h),
          Row(
            children: [
              SizedBox(width: 10.w),
              Expanded(
                child: appButton(
                    btnColor: AppConfig.colors.secondaryThemeColor,
                    textColor: AppConfig.colors.whiteColor,
                    title: "NO, THANKS.",
                    onTab: () async {
                      if (kDebugMode) {
                        print(
                            "user type is ${authProvider.isProfessional ? UserType.professional : UserType.customer}");
                      }
                      Get.back();
                      await authProvider.registerUser(
                          authProvider.isProfessional
                              ? UserType.professional
                              : UserType.customer);
                    },
                    isIcon: false),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: appButton(
                    btnColor: AppConfig.colors.themeColor,
                    textColor: AppConfig.colors.whiteColor,
                    title: "YES!",
                    onTab: () {
                      if (kDebugMode) {
                        authProvider.continueAsProfessional();
                        print(
                            "user type is ${authProvider.isProfessional ? UserType.professional : UserType.customer}");
                        Get.back();
                      }
                    },
                    isIcon: false),
              ),
              SizedBox(width: 10.w),
            ],
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  /*  for Customers and Professionals*/
  Form signUpForm(AuthProvider authProvider) {
    return Form(
      key: signUpFormKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: [
          GlobalFormField(
            hint: "Enter your first Name",
            title: " First Name",
            titleColor: AppConfig.colors.fieldTitleColor,
            controller: authProvider.firstNameController,
            focusNode: authProvider.firstNameFocusNode,
            nextNode: authProvider.lastNameFocusNode,
            type: TextInputType.text,
            action: TextInputAction.next,
            textLimit: 25,
            validator: FieldValidator.validateFullName,
            isPassword: false,
            isEmail: false,
          ),
          GlobalFormField(
            hint: "Enter your last Name",
            title: "Last Name",
            titleColor: AppConfig.colors.fieldTitleColor,
            controller: authProvider.lasttNameController,
            focusNode: authProvider.lastNameFocusNode,
            nextNode: authProvider.emailFocusNode,
            type: TextInputType.text,
            action: TextInputAction.next,
            textLimit: 25,
            validator: FieldValidator.validateFullName,
            isPassword: false,
            isEmail: false,
          ),
          GlobalFormField(
            isEmail: true,
            hint: "Enter your email",
            title: "Email",
            titleColor: AppConfig.colors.fieldTitleColor,
            controller: authProvider.emailController,
            focusNode: authProvider.emailFocusNode,
            nextNode: authProvider.passwordFocusNode,
            type: TextInputType.text,
            action: TextInputAction.next,
            textLimit: 30,
            validator: FieldValidator.validateEmail,
            isPassword: false,
          ),
          GlobalFormField(
            isPassword: true,
            title: "Password",
            hint: "Enter your password",
            titleColor: AppConfig.colors.fieldTitleColor,
            controller: authProvider.passwordController,
            focusNode: authProvider.passwordFocusNode,
            nextNode: authProvider.confirmPasswordFocusNode,
            type: TextInputType.text,
            action: TextInputAction.next,
            textLimit: 25,
            validator: FieldValidator.validatePasswordSignup,
            isEmail: false,
          ),
          GlobalFormField(
            isPassword: true,
            title: "Confirm Password",
            hint: "Enter your confirm password",
            titleColor: AppConfig.colors.fieldTitleColor,
            controller: authProvider.confirmPasswordController,
            focusNode: authProvider.confirmPasswordFocusNode,
            type: TextInputType.text,
            action: TextInputAction.done,
            textLimit: 25,
            validator: FieldValidator.validateConfirmPasswordSignup,
            nextNode: FocusNode(),
            isEmail: false,
          ),
        ],
      ),
    );
  }

  Widget _termsConditions(AuthProvider model) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.paddingSizeDefault,
        right: Dimensions.paddingSizeDefault,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              model.selectTermToggle();
            },
            child: Container(
              height: 22.h,
              width: 22.h,
              decoration: BoxDecoration(
                color: model.selectTerms
                    ? AppConfig.colors.themeColor
                    : AppConfig.colors.fillColor,
                border: Border.all(color: AppConfig.colors.fieldBorderColor),
                borderRadius: BorderRadius.circular(3.sp),
              ),
              child: Icon(
                Icons.check,
                color: model.selectTerms
                    ? AppConfig.colors.whiteColor
                    : AppConfig.colors.fillColor,
                size: 13.sp,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              ShowMessage.toast("Terms & Conditions");
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              child: RichText(
                text: TextSpan(
                  text: "I agree with ",
                  style: latoRegular.copyWith(
                      fontSize: 16.sp,
                      color: AppConfig.colors.secondaryThemeColor),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Terms & Conditions",
                      style: latoBlack.copyWith(
                          fontSize: 16.sp, color: AppConfig.colors.themeColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* Only for For Professionals*/
  Form professionalForm(AuthProvider authProvider) {
    return Form(
      key: professionalFormKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDropDownField(
              title: "Profession",
              titleColor: AppConfig.colors.fieldTitleColor),
          SizedBox(height: 15.h),
          GlobalFormField(
            hint: "Enter your experience",
            title: " Experience (in Years)",
            titleColor: AppConfig.colors.fieldTitleColor,
            prefixIcon: null,
            controller: authProvider.experienceController,
            focusNode: authProvider.experienceFocusNode,
            nextNode: authProvider.descriptionFocusNode,
            type: TextInputType.number,
            action: TextInputAction.next,
            textLimit: 25,
            validator: FieldValidator.validateField,
            isPassword: false,
            isEmail: false,
          ),
          SizedBox(height: 15.h),
          GlobalFormField(
            hint: "Describe your self",
            title: "Additional Information",
            titleColor: AppConfig.colors.secondaryThemeColor,
            prefixIcon: null,
            controller: authProvider.descriptionController,
            focusNode: authProvider.descriptionFocusNode,
            nextNode: FocusNode(),
            type: TextInputType.text,
            action: TextInputAction.next,
            textLimit: 250,
            maxLines: 4,
            validator: FieldValidator.validateDescription,
            isPassword: false,
            isEmail: false,
          ),
          SizedBox(height: 15.h),
          Container(
            margin: EdgeInsets.only(
                left: Dimensions.paddingSizeDefault,
                right: Dimensions.paddingSizeDefault),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Additional Documents",
                  style: latoRegular.copyWith(
                      fontSize: 18.sp,
                      color: AppConfig.colors.secondaryThemeColor),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  "PDF and Images only (Maximum 2 files)",
                  style: latoBold.copyWith(
                      fontSize: 16.sp,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xffD9D4D5)),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  width: Get.width,
                  height: 120.h,
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                      color: AppConfig.colors.fillColor,
                      border:
                          Border.all(color: AppConfig.colors.fieldBorderColor),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.sp),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      documentFileWidget(
                        doc: authProvider.doc1,
                        authProvider: authProvider,
                        onTab: () {
                          if (authProvider.doc1 != null &&
                              isPDF(authProvider.doc1!.path)) {
                            /* if document is selected and its pdf show in pdf viewer*/
                            Get.to(DocumentViewerSignUp(
                              doc: authProvider.doc1!,
                              isPDF: true,
                            ));
                          } else if (authProvider.doc1 != null &&
                              isImage(authProvider.doc1!.path)) {
                            /* if document is selected and its image show in image viewer*/
                            Get.to(DocumentViewerSignUp(
                              doc: authProvider.doc1!,
                              isPDF: false,
                            ));
                          } else {
                            /* if noting is selected show bottom sheet to select*/
                            authProvider.getDocumentFile(0);
                          }
                        },
                        index: 0,
                      ),
                      SizedBox(width: 20.w),
                      documentFileWidget(
                        doc: authProvider.doc2,
                        authProvider: authProvider,
                        onTab: () {
                          if (authProvider.doc2 != null &&
                              isPDF(authProvider.doc2!.path)) {
                            Get.to(DocumentViewerSignUp(
                              doc: authProvider.doc2!,
                              isPDF: true,
                            ));
                          } else if (authProvider.doc2 != null &&
                              isImage(authProvider.doc2!.path)) {
                            Get.to(DocumentViewerSignUp(
                              doc: authProvider.doc2!,
                              isPDF: false,
                            ));
                          } else {
                            authProvider.getDocumentFile(1);
                          }
                        },
                        index: 1,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget documentFileWidget(
      {required AuthProvider authProvider,
      File? doc,
      required Function onTab,
      required int index}) {
    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: InkWell(
              onTap: () {
                onTab();
              },
              child: Container(
                  decoration: DottedDecoration(
                      shape: Shape.box,
                      color: AppConfig.colors.themeColor,
                      borderRadius: BorderRadius.all(Radius.circular(10.sp))),
                  child: (doc != null && isImage(doc.path))
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.sp, vertical: 8.sp),
                          child: Image.file(doc, fit: BoxFit.fill),
                        )
                      : (doc != null && isPDF(doc.path))
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.attach_file,
                                      color: AppConfig.colors.themeColor),
                                  Padding(
                                      padding: EdgeInsets.all(2.0.sp),
                                      child: Text('View',
                                          style: latoRegular.copyWith(
                                              fontSize: 16.sp,
                                              decoration:
                                                  TextDecoration.underline,
                                              fontStyle: FontStyle.italic,
                                              color:
                                                  AppConfig.colors.themeColor)))
                                ],
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.all(30.sp),
                              child: Image.asset(
                                  AppConfig.images.uploadDocument))),
            ),
          ),
          if (doc != null)
            Positioned(
                top: 0.sp,
                right: 0.sp,
                child: Column(
                  children: [
                    documentBtn(
                        icon: Icons.edit,
                        onTab: () {
                          authProvider.getDocumentFile(index);
                        }),
                    documentBtn(
                        icon: Icons.delete,
                        onTab: () {
                          authProvider.deleteDocument(index);
                        }),
                  ],
                ))
        ],
      ),
    );
  }

  Widget documentBtn({required IconData icon, required Function onTab}) {
    return InkWell(
      onTap: () {
        onTab();
      },
      child: Card(
        color: AppConfig.colors.themeColor,
        child: Padding(
          padding: EdgeInsets.all(3.0.sp),
          child: Icon(
            icon,
            size: 14.sp,
            color: AppConfig.colors.whiteColor,
          ),
        ),
      ),
    );
  }

  bool isImage(String path) {
    final mimeType = lookupMimeType(path);
    return mimeType!.startsWith('image/');
  }

  bool isPDF(String path) {
    final mimeType = lookupMimeType(path);
    return mimeType!.startsWith('application/pdf');
  }
}
