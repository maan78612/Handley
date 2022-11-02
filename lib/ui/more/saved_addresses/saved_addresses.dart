import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/model_classes/saved_addresses.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/ui/more/saved_addresses/address_form_screen.dart';
import 'package:social_pro/ui/shared/app_button.dart';
import 'package:social_pro/ui/shared/custom_app_bar.dart';
import 'package:social_pro/ui/shared/custom_loader.dart';



class SavedAddresses extends StatelessWidget {
  const SavedAddresses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, _) {
      return ModalProgressHUD(
        inAsyncCall: appProvider.isLoading,
        progressIndicator: customLoader(),
        child: Scaffold(
          backgroundColor: AppConfig.colors.whiteColor,
          appBar: customAppBar(
              onTab: () {
                Get.back();
              },
              title: "Saved Addresses"),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20..sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(appProvider.userSavedAddress.length,
                      (index) {
                    SavedAddressesModel address =
                        appProvider.userSavedAddress[index];
                    return savedAddressCard(address, appProvider, index);
                  }),
                ),
                if (appProvider.userSavedAddress.isNotEmpty)
                  customDivider()
                else
                  SizedBox(height: 20.h),
                appButton(
                    btnColor: AppConfig.colors.themeColor,
                    textColor: AppConfig.colors.whiteColor,
                    title: "ADD NEW ADDRESS",
                    onTab: () {
                      appProvider.onTabAddNewAddress();
                    },
                    isIcon: false),
              ],
            ),
          ),
        ),
      );
    });
  }

  Padding customDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.sp),
      child: Row(
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
            style: latoRegular.copyWith(
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
    );
  }

  Widget savedAddressCard(
      SavedAddressesModel address, AppProvider appProvider, int index) {
    return GestureDetector(
      onTap: () async {
        await appProvider.updatesUserAddress(address);
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color:
                    appProvider.selectedAddress?.addressID == address.addressID
                        ? AppConfig.colors.themeColor
                        : Color(0xffD9D4D5)),
            borderRadius: BorderRadius.circular(10.sp),
            color: AppConfig.colors.whiteColor),
        padding: EdgeInsets.all(12.sp),
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
                  Text(address.addressName,
                      style: latoBold.copyWith(
                          fontSize: 14.sp,
                          color: AppConfig.colors.secondaryThemeColor)),
                  Text(address.address,
                      style: latoRegular.copyWith(
                          fontSize: 12.sp,
                          color: AppConfig.colors.secondaryThemeColor))
                ],
              ),
            ),
            SizedBox(width: 20.w),
            editIcon(address),
            SizedBox(width: 10.w),
            deleteIcon(appProvider, address, index),
          ],
        ),
      ),
    );
  }

  Container locationIcon() {
    return Container(
        padding: EdgeInsets.all(8.sp),
        decoration: BoxDecoration(
          color: Color(0xffFDEEED),
          borderRadius: BorderRadius.circular(20.sp),
        ),
        child: Image.asset(
          AppConfig.images.location,
          color: AppConfig.colors.themeColor,
          width: 18.w,
          height: 18.h,
        ));
  }

  Widget editIcon(SavedAddressesModel address) {
    return GestureDetector(
      onTap: () {
        Get.to(AddressFormScreen(
          isEdit: true,
          location: address.location,
          selectedAddress: address,
        ));
      },
      child: Container(
          padding: EdgeInsets.all(6.sp),
          decoration: BoxDecoration(
            color: Color(0xffFDEEED),
            borderRadius: BorderRadius.circular(10.sp),
          ),
          child: Icon(
            Icons.edit,
            color: AppConfig.colors.themeColor,
            size: 16.sp,
          )),
    );
  }

  Widget deleteIcon(
      AppProvider appProvider, SavedAddressesModel address, int index) {
    return GestureDetector(
      onTap: () {
        appProvider.deleteSavedAddress(address, index);
      },
      child: Container(
          padding: EdgeInsets.all(6.sp),
          decoration: BoxDecoration(
            color: AppConfig.colors.themeColor,
            borderRadius: BorderRadius.circular(10.sp),
          ),
          child: Icon(
            Icons.delete,
            color: AppConfig.colors.whiteColor,
            size: 16.sp,
          )),
    );
  }
}
