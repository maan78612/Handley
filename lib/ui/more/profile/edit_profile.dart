import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/ui/auth/widget/top_image_card.dart';
import 'package:social_pro/ui/shared/app_button.dart';
import 'package:social_pro/ui/shared/custom_app_bar.dart';
import 'package:social_pro/ui/shared/custom_loader.dart';
import 'package:social_pro/ui/shared/custom_text_field.dart';
import 'package:social_pro/utilities/dimension.dart';
import 'package:social_pro/utilities/validator.dart';

import '../../../utilities/enums.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  DateTime? birthDate;
  String initValue = "Select your Birth Date";

  @override
  void initState() {
    onInIt();
    super.initState();
  }

  final editFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, model, _) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: AppConfig.colors.whiteColor,
          appBar: customAppBar(
              onTab: () {
                Get.back();
              },
              title: 'Profile'),
          body: ModalProgressHUD(
            inAsyncCall: model.isLoading,
            progressIndicator: customLoader(),
            child: SingleChildScrollView(
              child: ProfileCard(model),
            ),
          ),
        ),
      );
    });
  }

  Widget ProfileCard(AuthProvider authProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TopImageCard(),
          editProfileForm(authProvider),
          SizedBox(height: 10.h),
          genderSelection(authProvider),
          SizedBox(height: 10.h),
          dob(authProvider),
          SizedBox(height: 20.h),
          appButton(
              btnColor: AppConfig.colors.themeColor,
              textColor: AppConfig.colors.whiteColor,
              title: "SAVE PROFILE",
              onTab: () {
                authProvider.saveProfile(editFormKey);
              },
              isIcon: false),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget genderSelection(AuthProvider authProvider) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
          margin: EdgeInsets.only(
              left: Dimensions.paddingSizeDefault,
              right: Dimensions.paddingSizeDefault,
              top: Dimensions.paddingSmallSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Gender",
                style: latoRegular.copyWith(
                    fontSize: 18.sp,
                    color: AppConfig.colors.secondaryThemeColor),
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: radioBtn(authProvider, UserGender.male, "Male")),
                  SizedBox(width: 30.w),
                  Expanded(
                      child:
                          radioBtn(authProvider, UserGender.female, "Female")),
                ],
              ),
            ],
          )),
    );
  }

  Widget radioBtn(
      AuthProvider authProvider, UserGender userGender, String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          authProvider.gender = userGender;
          print(authProvider.gender!.index);
        });
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
            border: Border.all(color: AppConfig.colors.fieldBorderColor),
            color: AppConfig.colors.fillColor),
        child: Row(
          children: [
            Radio(
              value: userGender,
              groupValue: authProvider.gender,
              onChanged: (value) {
                setState(() {
                  authProvider.gender = userGender;
                  print(authProvider.gender!.index);
                });
              },
              fillColor: MaterialStateColor.resolveWith(
                  (states) => AppConfig.colors.themeColor),
            ),
            SizedBox(width: 5.w),
            Text(
              title,
              style: latoBold.copyWith(
                  fontSize: 16.sp, color: AppConfig.colors.secondaryThemeColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget dob(AuthProvider authProvider) {
    return GestureDetector(
      onTap: () async {
        final datePick = await showDatePicker(
            context: context,
            initialDate: new DateTime.now(),
            firstDate: new DateTime(1900),
            lastDate: new DateTime(2100));
        if (datePick != null && datePick != birthDate) {
          setState(() {
            print(datePick);
            birthDate = datePick;
            authProvider.birthDateUser = Timestamp.fromDate(birthDate!);
          });
        }
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
            margin: EdgeInsets.only(
                left: Dimensions.paddingSizeDefault,
                right: Dimensions.paddingSizeDefault,
                top: Dimensions.paddingSmallSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Date of Birth",
                  style: latoRegular.copyWith(
                      fontSize: 18.sp,
                      color: AppConfig.colors.secondaryThemeColor),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(Dimensions.radiusDefault)),
                      border:
                          Border.all(color: AppConfig.colors.fieldBorderColor),
                      color: AppConfig.colors.fillColor),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 13.sp, vertical: 15.h),
                    child: Text((birthDate != null)
                        ? DateFormat.yMd().format(birthDate!)
                        : initValue),
                  ),
                )
              ],
            )),
      ),
    );
  }

  Form editProfileForm(AuthProvider authProvider) {
    return Form(
      key: editFormKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
            nextNode: FocusNode(),
            type: TextInputType.text,
            action: TextInputAction.next,
            textLimit: 25,
            validator: FieldValidator.validateFullName,
            isPassword: false,
            isEmail: false,
          ),
          disabledFields(title: 'Email', info: AppUser.user.email),
        if(AppUser.user.userType==UserType.professional)  editFormForOnlyProfessional(authProvider),
        ],
      ),
    );
  }

  Column editFormForOnlyProfessional(AuthProvider authProvider) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: disabledFields(
                      title: 'Profession', info: AppUser.user.profession!.title),
                ),
                Expanded(
                  child: GlobalFormField(
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
                ),
              ],
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
          ],
        );
  }

  Container disabledFields({required String title, required String info}) {
    return Container(
        margin: EdgeInsets.only(
            left: Dimensions.paddingSizeDefault,
            right: Dimensions.paddingSizeDefault,
            top: Dimensions.paddingSmallSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: latoRegular.copyWith(
                  fontSize: 18.sp, color: AppConfig.colors.fieldTitleColor),
            ),
            SizedBox(height: 15.h),
            Container(
              height: 55.sp,
              width: Get.width,
              decoration: BoxDecoration(
                  color: AppConfig.colors.fillColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                  border: Border.all(color: AppConfig.colors.fieldBorderColor)),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10.sp),
              child: Text(
                info,
                style: latoBold.copyWith(
                    fontSize: 16.sp, color: Color(0xff3A3335)),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
          ],
        ));
  }

  void onInIt() {
    var auth = Provider.of<AuthProvider>(context, listen: false);
    auth.gender = null;
    auth.firstNameController.text = AppUser.user.firstName;
    auth.lasttNameController.text = AppUser.user.lastName;

    if (AppUser.user.gender != null) {
      switch (AppUser.user.gender) {
        case 0:
          auth.gender = UserGender.male;
          break;

        case 1:
          auth.gender = UserGender.female;
          break;
      }
    }

    if (AppUser.user.dob != null) {
      birthDate = AppUser.user.dob!.toDate();
      auth.birthDateUser = Timestamp.fromDate(birthDate!);
    }

    if (AppUser.user.userType == UserType.professional) {
      auth.descriptionController.text = AppUser.user.description!;
      auth.experienceController.text = AppUser.user.experience.toString();
    }
  }
}
