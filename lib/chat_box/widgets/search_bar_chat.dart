import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/provider/chat_provider.dart';
import 'package:social_pro/ui/chat/start_new_chat.dart';
import 'package:social_pro/ui/shared/custom_dialog.dart';
import 'package:social_pro/utilities/dimension.dart';
import 'package:social_pro/utilities/enums.dart';


class SearchBarChat extends StatefulWidget {
  State<SearchBarChat> createState() => _SearchBarChatState();
}

class _SearchBarChatState extends State<SearchBarChat> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<ChatProvider, AuthProvider, AppProvider>(
        builder: (context, chatProvider, authProvider, appProvider, child) {
      return SizedBox(
        height: 55.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 6,
              child: TextFormField(
                controller: chatProvider.chatTextEditingController,
                decoration: InputDecoration(
                  hintText: 'Search for people….',
                  filled: true,
                  hintStyle: latoBold.copyWith(
                      fontSize: 16.sp, color: const Color(0xffD9D4D5)),
                  fillColor: AppConfig.colors.fillColor,
                  suffixIcon: (chatProvider.searchFieldChat.isNotEmpty)
                      ? GestureDetector(
                          onTap: () {
                            chatProvider.clearSearchText();
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
                  chatProvider.search();
                },
                onEditingComplete: () {
                  chatProvider.onEditComplete();
                },
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  List<UserData> chatUsers = [];
                  /* Show Users to whom I interacted */
                  /* Checking My Interactions with other user on the basis of chat and booking */

                  /*===========CHECK IF I INITIATE BOOKING WITH OTHER USERS IF YES THEN ADD THAT OTHER USER  TO NEW CHAT USER LIST [chatUsers] ===============*/
                  appProvider.userBookings.forEach((booking) {
                    authProvider.allUser.forEach((user) {
                      if (!chatUsers.contains(user)) {
                        if (AppUser.user.userType == UserType.customer &&
                            user.email == booking.proId) {
                          chatUsers.add(user);
                        } else if (AppUser.user.userType == UserType.professional &&
                            user.email == booking.customerId) {
                          chatUsers.add(user);
                        }
                      }
                    });
                  });


                  if (chatUsers.isNotEmpty) {
                    print("start chat screen user length ${chatUsers.length}");

                    CustomDialog.startNewChatDialog(context, () => StartNewChat(chatUsers: chatUsers));
                  } else {
                    Get.snackbar(
                        "ALERTS",
                        AppUser.user.userType == UserType.customer
                            ? "No professionals found to message"
                            : "No users found to message",
                        colorText: AppConfig.colors.whiteColor,
                        backgroundColor: AppConfig.colors.themeColor);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppConfig.colors.themeColor,
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  padding: EdgeInsets.all(16.sp),
                  child: Image.asset(
                    AppConfig.images.startNewChat,
                    color: AppConfig.colors.whiteColor,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
