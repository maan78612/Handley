import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/chat_box/widgets/msg_shimmer.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/model_classes/message.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/chat_provider.dart';
import 'package:social_pro/utilities/enums.dart';


class PeopleTile extends StatefulWidget {
  UserData chatUserData;
  String roomID;

  final Function() onTap;

  PeopleTile(
      {required this.chatUserData, required this.onTap, required this.roomID});

  @override
  State<PeopleTile> createState() => _PeopleTileState();
}

class _PeopleTileState extends State<PeopleTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, p, _) {
      return StreamBuilder(
          stream: p.buildListStream(widget.roomID),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
            if (!snapShot.hasData) {
              return const MsgShimmerWidget();
            } else {
              List<Message> allMessages = [];
              List<Message> allUnreadMsgs = [];
              for (var element in snapShot.data!.docs) {
                allMessages.add(Message.fromJson(element.data()));
                allUnreadMsgs = allMessages
                    .where((element) =>
                        element.seen == false &&
                        element.receiverId == AppUser.user.email)
                    .toList();
              }
              Message? msg = (allUnreadMsgs.isNotEmpty)
                  ? allUnreadMsgs.first
                  : (allUnreadMsgs.isEmpty && allMessages.isNotEmpty)
                      ? allMessages.first
                      : null;

              /* If there is no messages then don't show Chat tile */
              return  InkWell(
                      onTap: () {
                        widget.onTap();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.sp),
                          border:
                              Border.all(color: Color(0xffD9D4D5), width: 2),
                          color: allUnreadMsgs.length == 0
                              ? AppConfig.colors.whiteColor
                              : Color(0xffFDEEED),
                        ),
                        margin:
                            EdgeInsets.symmetric(vertical: 8.sp, horizontal: 0),
                        padding: EdgeInsets.all(8.sp),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.all(4.sp),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.sp),
                                    border: Border.all(
                                        color: AppConfig.colors.themeColor)),
                                child: widget.chatUserData.imageUrl != ""
                                    ? CachedNetworkImage(
                                        imageUrl: widget.chatUserData.imageUrl,
                                        fit: BoxFit.cover,
                                        width: 40.w,
                                        height: 45.h,
                                      )
                                    : Padding(
                                        padding: EdgeInsets.all(5.sp),
                                        child: Image.asset(
                                          AppConfig.images.account,
                                          color: AppConfig.colors.themeColor,
                                          fit: BoxFit.contain,
                                          width: 30.w,
                                          height: 35.h,
                                        ),
                                      )),
                            SizedBox(width: 20.w),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.chatUserData.firstName} ${widget.chatUserData.lastName}",
                                    style: latoBold.copyWith(
                                        fontSize: 14.sp,
                                        color: AppConfig
                                            .colors.secondaryThemeColor),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 10.h),
                                  if (msg != null)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Icon(Icons.done_all,
                                            size: 11.sp,
                                            color: allMessages.first.seen
                                                ? AppConfig.colors.themeColor
                                                : AppConfig.colors
                                                    .secondaryThemeColor),
                                        SizedBox(width: 5.w),
                                        if (msg.type == MessageTypeEnums.text.index)
                                          Text(
                                            msg.msg,
                                            style: latoRegular.copyWith(
                                                fontSize: 12.sp,
                                                color: AppConfig.colors
                                                    .secondaryThemeColor),
                                            textAlign: TextAlign.center,
                                          ),
                                        if (msg.type == MessageTypeEnums.image.index)
                                          Image.asset(
                                            AppConfig.images.gallery,
                                            width: 15.sp,
                                            height: 15.sp,
                                          ),
                                        if (msg.type == MessageTypeEnums.file.index ||msg.type == MessageTypeEnums.pdf.index)
                                          Image.asset(
                                            AppConfig.images.file,
                                            width: 15.sp,
                                            height: 15.sp,
                                          ),
                                      ],
                                    )
                                  else if(allMessages.isEmpty)   Text(
                                    "No Conversations",
                                    style: latoRegular.copyWith(
                                        fontSize: 12.sp,
                                        color:Color(0xffD9D4D5)),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (msg != null)
                                  Text(
                                    DateFormat('hh:mm a')
                                        .format(msg.sentAt.toDate()),
                                    style: latoRegular.copyWith(
                                        fontSize: 12.sp,
                                        color: AppConfig
                                            .colors.secondaryThemeColor),
                                  ),
                                SizedBox(height: 10.h),
                                if (allUnreadMsgs.isNotEmpty)
                                  Container(
                                    alignment: Alignment.center,
                                    width: 23.sp,
                                    height: 23.sp,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(20.sp),
                                      color: AppConfig.colors.themeColor,
                                    ),
                                    child: Text(
                                      '${allUnreadMsgs.length}',
                                      style: latoRegular.copyWith(
                                          fontSize: 12.sp,
                                          color: AppConfig.colors.whiteColor),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
            }
          });
    });
  }
}
