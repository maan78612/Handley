import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/ui/shared/custom_loader.dart';
import 'package:social_pro/ui/shared/customers_list.dart';
import 'package:social_pro/ui/shared/professional_list.dart';
import 'package:social_pro/utilities/enums.dart';

class StartNewChat extends StatelessWidget {
  List<UserData> chatUsers;

  StartNewChat({Key? key, required this.chatUsers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, _) {
      return ModalProgressHUD(
        inAsyncCall: appProvider.isLoading,
        progressIndicator: customLoader(),
        child: SizedBox(
          height: 600.h,
          width: Get.width * 0.8,
          child: Column(
            children: [
              SizedBox(height: 25.sp),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text("Chat With",
                          style: latoBlack.copyWith(
                              fontSize: 16.sp,
                              color: AppConfig.colors.secondaryThemeColor)),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.cancel_outlined,
                          size: 24.sp,
                          color: AppConfig.colors.secondaryThemeColor),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    newConversationList(),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget newConversationList() {
    return (AppUser.user.userType == UserType.customer)
        ? ProfessionalsList(professionals: chatUsers)
        : CustomersList(professionals: chatUsers);
  }
}
