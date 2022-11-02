import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/maps_box/map_screen_to_select_location_with_click.dart';
import 'package:social_pro/maps_box/widgets/static_marker_map.dart';
import 'package:social_pro/model_classes/location_model.dart';
import 'package:social_pro/model_classes/saved_addresses.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/provider/map_provider.dart';
import 'package:social_pro/ui/more/saved_addresses/widgets/adress_form_field.dart';
import 'package:social_pro/ui/shared/app_button.dart';
import 'package:social_pro/ui/shared/custom_app_bar.dart';
import 'package:social_pro/ui/shared/custom_loader.dart';

import 'package:social_pro/utilities/validator.dart';


class AddressFormScreen extends StatefulWidget {
  /* For edit address*/
  bool isEdit;
  SavedAddressesModel? selectedAddress;

  /* for both Edit address (sends selectedAddress location) and add address(sends current location if enable otherwise location from IP address)*/
  Location location;

  AddressFormScreen(
      {Key? key,
      required this.isEdit,
      this.selectedAddress,
      required this.location})
      : super(key: key);

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final addressFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onInit();
    });

    super.initState();
  }

  onInit() async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    print(widget.location.toJson());

    print(widget.isEdit ? "Edit address" : "Add Address");
    if (widget.isEdit && widget.selectedAddress != null) {
      /* initially set selected address data whom we want to edit */
      /* Using widget.location instead of [widget.selectedAddress.location] because when we change it and we back to previous screen it shows updated location and marker in static map*/
      appProvider.addressFormScreenInitEdit(
          widget.selectedAddress!, widget.location);
    } else {
      /* initially set clear all controllers and set location coming from previous screen*/
      appProvider.addressFormScreenInit(widget.location);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, MapProvider>(
        builder: (context, appProvider, mapProvider, _) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ModalProgressHUD(
          inAsyncCall: appProvider.isLoading,
          progressIndicator: customLoader(),
          child: Scaffold(
            appBar: customAppBar(
                onTab: () {
                  Get.back();
                },
                title: widget.isEdit ? "Edit Address" : "Add Address"),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20..sp),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.sp),
                      child: Text("Service Location",
                          style: latoBlack.copyWith(
                              fontSize: 16.sp,
                              color: AppConfig.colors.secondaryThemeColor)),
                    ),
                    bookingLocation(appProvider, mapProvider),
                    StaticMarkerMap(location: widget.location),
                    addressTextFields(appProvider),
                    SizedBox(height: 10.h),
                    appButton(
                        title: "SAVE ADDRESS",
                        textColor: AppConfig.colors.whiteColor,
                        isIcon: false,
                        btnColor: AppConfig.colors.themeColor,
                        onTab: () {
                          if (addressFormKey.currentState!.validate()) {
                            print(widget.selectedAddress);
                            appProvider.saveAddress(
                                widget.isEdit, widget.selectedAddress);
                          }
                        }),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Column addressTextFields(AppProvider appProvider) {
    return Column(
      children: [
        Form(
          key: addressFormKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddressFormField(
                title: "Address Name",
                hint: "Home, office..",
                titleColor: AppConfig.colors.fieldTitleColor,
                controller: appProvider.addressNameCont,
                focusNode: appProvider.addressNameNode,
                nextNode: appProvider.buildingNameNode,
                type: TextInputType.text,
                action: TextInputAction.next,
                validator: FieldValidator.validateField,
                textLimit: 50,
              ),
              AddressFormField(
                title: "Building Name",
                hint: "Almas Tower",
                titleColor: AppConfig.colors.fieldTitleColor,
                controller: appProvider.buildingNameCont,
                focusNode: appProvider.buildingNameNode,
                nextNode: appProvider.apartmentNumNode,
                type: TextInputType.text,
                action: TextInputAction.next,
                textLimit: 50,
                validator: FieldValidator.validateField,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AddressFormField(
                      title: "Apartment No.",
                      hint: "19C",
                      titleColor: AppConfig.colors.fieldTitleColor,
                      controller: appProvider.apartmentNumCont,
                      focusNode: appProvider.apartmentNumNode,
                      nextNode: appProvider.floorNumNode,
                      type: TextInputType.text,
                      action: TextInputAction.next,
                      textLimit: 50,
                      validator: FieldValidator.validateField,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: AddressFormField(
                      title: "Floor No.",
                      hint: "19",
                      titleColor: AppConfig.colors.fieldTitleColor,
                      controller: appProvider.floorNumCont,
                      focusNode: appProvider.floorNumNode,
                      nextNode: appProvider.additionalDirectionNode,
                      type: TextInputType.number,
                      action: TextInputAction.next,
                      textLimit: 50,
                      validator: FieldValidator.validateField,
                    ),
                  ),
                ],
              ),
              AddressFormField(
                title: "Additional Directions",
                hint: "Cafe Nero nearby…",
                titleColor: AppConfig.colors.fieldTitleColor,
                controller: appProvider.additionalDirectionCont,
                focusNode: appProvider.additionalDirectionNode,
                type: TextInputType.text,
                action: TextInputAction.done,
                maxLines: 3,
                textLimit: 100,
                validator: null,
                nextNode: FocusNode(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container bookingLocation(AppProvider appProvider, MapProvider mapProvider) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          locationIcon(),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Booking Location",
                    style: latoBold.copyWith(
                        fontSize: 14.sp,
                        color: AppConfig.colors.secondaryThemeColor)),
                Text("${appProvider.selectedAddressLocationAddress}",
                    style: latoRegular.copyWith(
                        fontSize: 12.sp,
                        color: AppConfig.colors.secondaryThemeColor))
              ],
            ),
          ),
          modifyBtn(appProvider, mapProvider),
        ],
      ),
    );
  }

  Container locationIcon() {
    return Container(
        padding: EdgeInsets.all(6.sp),
        decoration: BoxDecoration(
          color: Color(0xffFDEEED),
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Image.asset(
          AppConfig.images.location,
          color: AppConfig.colors.themeColor,
          width: 18.w,
          height: 18.h,
        ));
  }

  Widget modifyBtn(AppProvider appProvider, MapProvider mapProvider) {
    return TextButton(
        onPressed: () async {
          Get.off(MapScreenToSelectLocationWithClick(
            location: widget.location,
            isEdit: widget.isEdit,
            selectedAddress: widget.selectedAddress,
          ));
        },
        child: Text(
          "Modify",
          style: latoBold.copyWith(
              fontSize: 12.sp, color: AppConfig.colors.themeColor),
        ));
  }
}
