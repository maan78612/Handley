import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/utilities/dimension.dart';

class CustomDropDownField extends StatefulWidget {
  final String? title;
  final Color titleColor;
   CustomDropDownField({Key? key,  this.title,  required this.titleColor}) : super(key: key);

  @override
  State<CustomDropDownField> createState() => _CustomDropDownFieldState();
}

class _CustomDropDownFieldState extends State<CustomDropDownField> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return customDropDownFormField(auth);
        });

  }

  Container customDropDownFormField(AuthProvider authProvider) {
    return Container(
      margin: EdgeInsets.only(
          left: Dimensions.paddingSizeDefault,
          right: Dimensions.paddingSizeDefault,
          top: Dimensions.paddingSmallSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,


        children: [
          Text(
            widget.title ?? "",
            style: latoRegular.copyWith(
                fontSize: 18.sp,
                color: widget.titleColor),
          ),
          SizedBox(
            height: 5.h,
          ),
          DropdownButtonFormField(
            hint: const Text("Select your Profession"),
            items: authProvider.professionMap,
            onChanged: (newVal) => setState(() {
              authProvider.selectProfession(newVal);
            }),
            isExpanded: true,
            focusNode: authProvider.dropDownFocusNode,
            validator: (value) =>
            value == null ? 'Please fill in your profession' : null,
            value: authProvider.selectedProfession,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                hintStyle: TextStyle(
                    fontSize: Dimensions.fontSizeExtraSmall,
                    color: AppConfig.colors.hintColor),
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
                filled: true,
                isDense: true,
                fillColor: AppConfig.colors.fillColor),
          ),
        ],
      ),
    );
  }
}
