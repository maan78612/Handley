import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/utilities/dimension.dart';


//////////////////////////////////////////////////////////
//////////////////////// Classes ////////////////////////
////////////////////////////////////////////////////////

// form field class
class GlobalFormField extends StatefulWidget {

  final String? hint, title, prefixIcon;
  final Color titleColor;
  final TextEditingController controller;
  String? Function(String?)? validator;
  final bool isPassword;
  final bool isEmail;
  final FocusNode focusNode, nextNode;
  int maxLines;

  GlobalFormField({
    Key? key,

    required this.hint,
    required this.title,
    this.prefixIcon,
    required this.titleColor,
    required this.controller,
    required this.focusNode,
    required this.nextNode,
    required this.isPassword,
    required this.type,
    required this.action,
    required this.validator,
    required this.textLimit,
    required this.isEmail,
    this.maxLines = 1,
  }) : super(key: key);

  final TextInputType type;
  final TextInputAction action;
  final int textLimit;

  @override
  _GlobalFormFieldState createState() => _GlobalFormFieldState();
}

class _GlobalFormFieldState extends State<GlobalFormField> {
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
    return Consumer<AuthProvider>(builder: (context, auth, _) {
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
                    fontSize: 18.sp, color: widget.titleColor),
              ),
              SizedBox(height: 15.h),
              TextFormField(

                  obscureText: widget.isPassword ? obscureText : false,
                  textAlign: TextAlign.start,
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  maxLines: widget.maxLines,
                  style: latoBold.copyWith(fontSize: 16.sp,color: Color(0xff3A3335)),
                  onFieldSubmitted: (val) {
                    if (widget.isPassword) {
                      Provider.of<AuthProvider>(Get.context!, listen: false)
                          .matchPassProvider( val);
                    }
                    setState(() {
                      FocusScope.of(Get.context!).requestFocus(widget.nextNode);
                    });
                  },
                  textInputAction: widget.action,
                  decoration: InputDecoration(
                    suffixIcon: widget.isPassword
                        ? IconButton(
                            icon: Icon(
                                obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppConfig.colors.themeColor),
                            onPressed: _toggle,
                          )
                        : widget.isEmail
                            ? Icon(
                                auth.isAcceptedEmail == 1
                                    ? Icons.check
                                    : auth.isAcceptedEmail == 0
                                        ? Icons.close
                                        : null,
                                color: auth.isAcceptedEmail == 1
                                    ? Colors.green
                                    : auth.isAcceptedEmail == 0
                                        ? Colors.red
                                        : null,
                              )
                            : null,
                    isDense: true,
                    hintText: widget.hint,
                    prefixIcon: widget.prefixIcon != null
                        ? Container(
                            padding:
                                EdgeInsets.all(Dimensions.paddingSizeDefault),
                            height: 10.h,
                            width: 10.w,
                            child: Image.asset(
                              widget.prefixIcon!,
                            ),
                          )
                        : null,
                    fillColor: widget.focusNode.hasFocus
                        ? AppConfig.colors.whiteColor
                        : AppConfig.colors.fillColor,
                    filled: true,
                    hintStyle: TextStyle(
                        fontSize: 14.sp, color: AppConfig.colors.hintColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(Dimensions.radiusDefault)),
                      borderSide:
                          BorderSide(color: AppConfig.colors.fieldBorderColor),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(Dimensions.radiusDefault)),
                      borderSide:
                          BorderSide(color: AppConfig.colors.fieldBorderColor),
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
                  ),
                  onChanged: (value) {
                    if (widget.isPassword) {
                      Provider.of<AuthProvider>(Get.context!, listen: false)
                          .matchPassProvider(value);
                    } else if (widget.isEmail) {
                      Provider.of<AuthProvider>(Get.context!, listen: false)
                          .matchEmail( value);
                    } else {
                      return;
                    }
                    // ignore: unnecessary_statements
                  },
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
          ));
    });
  }

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}
