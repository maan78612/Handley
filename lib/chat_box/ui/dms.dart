import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/chat_box/services/chat_services.dart';
import 'package:social_pro/chat_box/ui/conversation.dart';
import 'package:social_pro/chat_box/ui/people_tile.dart';
import 'package:social_pro/chat_box/widgets/msg_shimmer.dart';
import 'package:social_pro/chat_box/widgets/search_bar_chat.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/model_classes/chat_room_model.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/chat_provider.dart';
import 'package:social_pro/ui/shared/empty_screen.dart';



class DMs extends StatefulWidget {
  @override
  DMsState createState() => DMsState();
}

class DMsState extends State<DMs> {
  final ChatServices _chatServices = CSs();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, p, _) {
      if (p.isLoading) {
        return const MsgShimmer();
      } else {
        return Container(
          margin: EdgeInsets.symmetric(
              vertical: Get.height * 0.03, horizontal: Get.width * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBarChat(),
              SizedBox(height: 10),
              Expanded(
                  child: p.chatRooms.isEmpty
                      ? Center(
                          child: EmptyScreen(
                              image: AppConfig.images.chat,
                              message: 'No Conversations\nStart a new one!'))
                      : roomTile(p)),
              SizedBox(height: 10.h),
              // readMessages(p),
            ],
          ),
        );
      }
    });
  }

  Widget roomTile(ChatProvider chatProvider) {
    print(AppUser.user.firstName);
    return ListView(
        children: List.generate(chatProvider.chatRooms.length, (index) {
      ChatRoom room = chatProvider.chatRooms[index];
      String userToSearch =
          room.users.where((element) => element != AppUser.user.email).first;

      return FutureBuilder(
          future: _chatServices.getUserById(userToSearch),
          builder: (context, AsyncSnapshot<UserData?> userSnap) {
            if (!userSnap.hasData) {
              return const MsgShimmerWidget();
            } else {
              String name = userSnap.data!.firstName + userSnap.data!.lastName;
              if (name.toLowerCase().contains(chatProvider.searchFieldChat)) {
                return PeopleTile(
                  chatUserData: userSnap.data!,
                  onTap: () => Get.to(
                    Conversation(
                      room: room,
                      userData: userSnap.data!,
                    ),
                  ),
                  roomID: room.roomId,
                );
              } else {
                return SizedBox.shrink();
              }
            }
          });
    }));
  }
}
