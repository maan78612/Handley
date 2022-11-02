import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';

class AddressFormField extends StatefulWidget {
  final String? hint, title;
  final Color titleColor;
  final TextEditingController controller;
  String? Function(String?)? validator;

  final FocusNode focusNode, nextNode;
  int maxLines;

  AddressFormField({
    Key? key,
    required this.hint,
    required this.title,
    required this.titleColor,
    required this.controller,
    required this.focusNode,
    required this.nextNode,
    required this.type,
    required this.action,
    required this.validator,
    required this.textLimit,
    this.maxLines = 1,
  }) : super(key: key);

  final TextInputType type;
  final TextInputAction action;
  final int textLimit;

  @override
  _AddressFormFieldState createState() => _AddressFormFieldState();
}

class _AddressFormFieldState extends State<AddressFormField> {
  //to add listener to the login focus nodes
  bool isFocused = false;

  @override
  void initState() {
    // TODO: implement initState
    widget.focusNode.addListener(_onOnFocusNodeEvent);
    super.initState();
  }

  _onOnFocusNodeEvent() {
    if (mounted) {
      setState(() {
        isFocused = !isFocused;
      });
    }
  }

  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15.h),
        Text(
          widget.title ?? "",
          style:
              latoBold.copyWith(fontSize: 14.sp, color: widget.titleColor),
        ),
        SizedBox(height: 7.h),
        TextFormField(
            textAlign: TextAlign.start,
            controller: widget.controller,
            focusNode: widget.focusNode,
            maxLines: widget.maxLines,
            onFieldSubmitted: (val) {
              setState(() {
                FocusScope.of(Get.context!).requestFocus(widget.nextNode);
              });
            },
            textInputAction: widget.action,
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.hint,
              fillColor: widget.focusNode.hasFocus
                  ? AppConfig.colors.whiteColor
                  : AppConfig.colors.fillColor,
              filled: true,
              hintStyle:
                  latoRegular.copyWith(fontSize: 14.sp, color: AppConfig.colors.hintColor),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                borderSide:
                    BorderSide(color: AppConfig.colors.fieldBorderColor),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                borderSide:
                    BorderSide(color: AppConfig.colors.fieldBorderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                borderSide:
                    BorderSide(color: AppConfig.colors.enableBorderColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                borderSide:
                    BorderSide(color: AppConfig.colors.fieldBorderColor),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide:
                    BorderSide(color: AppConfig.colors.fieldBorderColor),
              ),
            ),
            onEditingComplete: () {
              setState(() {
                widget.focusNode.unfocus();
              });
            },
            keyboardType: widget.type,
            validator: widget.validator),
        SizedBox(
          height: 5.h,
        ),
      ],
    );
  }

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}
