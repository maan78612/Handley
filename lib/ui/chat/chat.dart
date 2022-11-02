import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_pro/chat_box/ui/dms.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/ui/shared/custom_app_bar.dart';

class CustomChat extends StatefulWidget {
  @override
  _CustomChatState createState() => _CustomChatState();
}

class _CustomChatState extends State<CustomChat> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppConfig.colors.whiteColor,
        appBar: customAppBar(
            title: 'Chats',
            onTab: () {
              Get.back();
            }),
        body: DMs(),
      ),
    );
  }
}
