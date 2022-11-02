import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/model_classes/booking_model.dart';
import 'package:social_pro/model_classes/ratingModel.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/ui/shared/custom_text_field.dart';
import 'package:social_pro/utilities/validator.dart';


class RatingDialog extends StatelessWidget {
  TextEditingController ratingController;
  BookingModel bookingData;

  RatingDialog({required this.ratingController, required this.bookingData});

  final GlobalKey<FormState> signInFromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, AuthProvider>(
        builder: (context, appProvider, authProvider, _) {
      return Dialog(
          child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.sp),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Please Give rating!",
                style: latoBlack.copyWith(
                    fontSize: 18.sp, color: AppConfig.colors.secondaryThemeColor),
              ),
              SizedBox(height: 30.h),
              rating(appProvider),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Rating is ${appProvider.ratingValue}",
                    style: latoRegular.copyWith(
                        fontSize: 16,
                        color: AppConfig.colors.secondaryThemeColor),
                  ),
                  SizedBox(width: 5.w),
                  const Icon(Icons.star, color: Colors.yellow, size: 18),
                ],
              ),
              reviewForm(),
              SizedBox(height: 10.h),
              reviewButtons(appProvider, bookingData, authProvider)
            ],
          ),
        ),
      ));
    });
  }

  /*====================Rating Widget======================== */
  Widget rating(AppProvider appProvider) {
    return RatingBar.builder(
      initialRating: appProvider.ratingValue,
      itemCount: 5,
      allowHalfRating: true,
      itemSize: 35,
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return const Icon(
              Icons.sentiment_very_dissatisfied,
              color: Colors.red,
            );
          case 1:
            return const Icon(
              Icons.sentiment_dissatisfied,
              color: Colors.redAccent,
            );
          case 2:
            return const Icon(
              Icons.sentiment_neutral,
              color: Colors.amber,
            );
          case 3:
            return const Icon(
              Icons.sentiment_satisfied,
              color: Colors.lightGreen,
            );
          case 4:
            return const Icon(
              Icons.sentiment_very_satisfied,
              color: Colors.green,
            );
          default:
            return const Icon(
              Icons.sentiment_neutral,
              color: Colors.amber,
            );
        }
      },
      onRatingUpdate: (rating) {
        appProvider.setRating(rating);
      },
    );
  }

  /*====================Review form======================== */
  Form reviewForm() {
    return Form(
      key: signInFromKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: [
          GlobalFormField(

            hint: "Write Review",
            title: "Review",
            titleColor: AppConfig.colors.fieldTitleColor,
            prefixIcon: null,
            controller: ratingController,
            type: TextInputType.text,
            action: TextInputAction.done,
            textLimit: 200,
            validator: FieldValidator.validateField,
            isPassword: false,
            maxLines: 4,
            isEmail: false,
            nextNode: FocusNode(),
            focusNode: FocusNode(),
          ),
        ],
      ),
    );
  }

  Row reviewButtons(AppProvider appProvider, BookingModel bookingData,
      AuthProvider authProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        closeReviewBtn(),
        submitReviewBtn(authProvider, bookingData, appProvider)
      ],
    );
  }

  /*==================== Submit Rating======================== */
  Widget submitReviewBtn(AuthProvider authProvider, BookingModel bookingData,
      AppProvider appProvider) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: AppConfig.colors.themeColor,
      ),
      onPressed: () async {
        await submitReviewOnPress(authProvider, bookingData, appProvider);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          "Submit",
          style: latoRegular.copyWith(
              fontSize: 14.sp, color: AppConfig.colors.whiteColor),
        ),
      ),
    );
  }

  Future<void> submitReviewOnPress(AuthProvider authProvider,
      BookingModel bookingData, AppProvider appProvider) async {
    if (signInFromKey.currentState!.validate()) {
      UserData professionalData = authProvider.allUser
          .where((element) => element.email == bookingData.proId)
          .first;
      RatingModel rating = RatingModel(
          review: ratingController.text,
          rating: appProvider.ratingValue,
          ratingDate: Timestamp.now());
      await appProvider.submitRating(
          booking: bookingData, newRating: rating, professional: professionalData);
      Get.back();
    }
  }

  /*==================== Close Rating======================== */
  ElevatedButton closeReviewBtn() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: AppConfig.colors.themeColor,
      ),
      onPressed: () {
        Get.back();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          "Close",
          style: latoRegular.copyWith(
              fontSize: 14.sp, color: AppConfig.colors.whiteColor),
        ),
      ),
    );
  }
}
