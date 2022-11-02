import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/provider/text_form_provider.dart';
import 'package:social_pro/utilities/dimension.dart';


class SearchBar extends StatefulWidget {

  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TextFormProvider>(
        builder: (context, textFormProvider, child) {
      return SizedBox(
        height: 55.h,
        child: TextFormField(
          // autofocus: true,

          controller: textFormProvider.textEditingController,
          decoration: InputDecoration(
            hintText: 'Search for service….',
            filled: true,
            hintStyle: latoBold.copyWith(
                fontSize: 16.sp, color: const Color(0xffD9D4D5)),
            fillColor: AppConfig.colors.fillColor,
            suffixIcon: (textFormProvider.searchField.isNotEmpty)
                ? GestureDetector(
                    onTap: () {
                      textFormProvider.clearSearchText();
                    },
                    child: Icon(
                      Icons.cancel_outlined,
                      color: Colors.red,
                      size: 18.sp,
                    ),
                  )
                : null,
            contentPadding: const EdgeInsets.all(0.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(Dimensions.radiusDefault)),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(Dimensions.radiusDefault)),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(Dimensions.radiusDefault)),
              borderSide:
                  BorderSide(color: AppConfig.colors.enableBorderColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(Dimensions.radiusDefault)),
              borderSide:
                  BorderSide(color: AppConfig.colors.fieldBorderColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide:
                  BorderSide(color: AppConfig.colors.fieldBorderColor),
            ),
            prefixIcon: Image.asset(
              AppConfig.images.search,
              scale: 3.sp,
              width: 13.w,
              height: 13.h,
              fit: BoxFit.scaleDown,
              color: AppConfig.colors.secondaryThemeColor,
            ),
          ),
          textInputAction: TextInputAction.search,
          cursorColor: AppConfig.colors.fieldTitleColor,
          onChanged: (val) {
            textFormProvider.search();
          },
          onEditingComplete: () {
            textFormProvider.onEditComplete();
          },
        ),
      );
    });
  }
}
