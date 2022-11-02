import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:provider/provider.dart';
import 'package:social_pro/chat_box/ui/document_viewer_chat.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/firebase_collections.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/model_classes/chat_room_model.dart';
import 'package:social_pro/model_classes/message.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/chat_provider.dart';
import 'package:social_pro/ui/shared/custom_loader.dart';
import 'package:social_pro/utilities/enums.dart';


class Conversation extends StatefulWidget {
  final ChatRoom room;
  final UserData userData;

  const Conversation({Key? key, required this.room, required this.userData})
      : super(key: key);

  @override
  ConversationState createState() =>
      ConversationState(room: room, receiverUser: userData);
}

class ConversationState extends State<Conversation> {
  late ChatRoom room;
  final UserData receiverUser;

  ConversationState({required this.room, required this.receiverUser});

  TextEditingController msgCont = TextEditingController();

  late File image;

  StreamSubscription<QuerySnapshot>? streamSubscription;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setSeenTrue();
      msgCont.addListener(() {
        if (msgCont.text.isEmpty) {
          setState(() {});
        }
      });
    });

    super.initState();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await disposeSubscription();
    print("stream close");
  }

  Future<void> disposeSubscription() async {
    await streamSubscription?.cancel().then((_) {
      streamSubscription = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
        builder: (context, chatProvider, _) => ModalProgressHUD(
              inAsyncCall: chatProvider.isLoading,
              progressIndicator: customLoader(),
              child: Scaffold(
                appBar: chatAppbar(chatProvider),
                body: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(AppConfig.images.logo),
                        fit: BoxFit.contain,
                        opacity: 0.2),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Expanded(child: buildListMessage(chatProvider)),
                      SizedBox(height: 10.h),
                      bottomTextFormField(chatProvider),
                    ],
                  ),
                ),
              ),
            ));
  }

  PreferredSize chatAppbar(ChatProvider chatProvider) {
    return PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom:
                  BorderSide(width: 2.0.sp, color: AppConfig.colors.themeColor),
            ),
            color: Color(0xffFDEEED),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(top: 16.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    chatProvider.clearSearchText();
                    await disposeSubscription();
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back,
                      color: AppConfig.colors.secondaryThemeColor),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: AppUser.user.userType == UserType.customer
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    Container(
                        padding: EdgeInsets.all(4.sp),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: AppConfig.colors.themeColor)),
                        child: receiverUser.imageUrl != ""
                            ? CachedNetworkImage(
                                imageUrl: receiverUser.imageUrl,
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${receiverUser.firstName} ${receiverUser.lastName}",
                          style: latoRegular.copyWith(
                              fontSize: 18.sp,
                              color: AppConfig.colors.secondaryThemeColor),
                          textAlign: TextAlign.center,
                        ),
                        if (AppUser.user.userType == UserType.customer)
                          SizedBox(height: 10.h),
                        if (AppUser.user.userType == UserType.customer)
                          Text(
                            "${receiverUser.profession?.title}",
                            style: latoBold.copyWith(
                                fontSize: 14.sp,
                                color: AppConfig.colors.secondaryThemeColor),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget bottomTextFormField(ChatProvider p) {
    return Container(
      margin: EdgeInsets.only(
          bottom: Platform.isIOS ? Get.height * 0.03 : Get.height * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0.sp),
        color: AppConfig.colors.fillColor,
      ),
      width: Get.width,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5.w),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              textAlign: TextAlign.start,
              controller: msgCont,
              maxLines: null,
              onChanged: (val) {
                setState(() {});
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Type your message…',
                filled: true,
                isDense: true,
                hintStyle: latoBold.copyWith(
                    fontSize: 14.sp, color: const Color(0xffD9D4D5)),
                fillColor: AppConfig.colors.fillColor,
                contentPadding: EdgeInsets.only(left: 5.w, right: 5.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.sp),
                  borderSide:
                      const BorderSide(width: 0, style: BorderStyle.none),
                ),
              ),
            ),
          ),
          Container(
            width: 2.w,
            height: 30.h,
            color: const Color(0xffD9D4D5),
            margin: EdgeInsets.only(right: 10.w),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.bounceOut,
            switchOutCurve: Curves.bounceOut,
            child: msgCont.text.isEmpty ? mediaOptions(p) : sendButton(p),
          )
        ],
      ),
    );
  }

  Widget mediaOptions(ChatProvider p) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          mediaIconsBtn(p, AppConfig.images.camera, () {
            _imgFromCamera(p);
          }),
          mediaIconsBtn(p, AppConfig.images.gallery, () {
            _imgFromGallery(p);
          }),
          mediaIconsBtn(p, AppConfig.images.file, () {
            _fileFromPhone(p);
          }),
        ],
      ),
    );
  }

  GestureDetector mediaIconsBtn(ChatProvider p, String image, Function onTab) {
    return GestureDetector(
      onTap: () {
        setState(() {
          onTab();
        });
      },
      child: Container(
        width: 28.w,
        height: 30.h,
        padding: EdgeInsets.all(6.0.sp),
        margin: EdgeInsets.only(right: 6.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sp),
            border: Border.all(color: const Color(0xffD9D4D5))),
        child: Image.asset(image),
      ),
    );
  }

  Widget sendButton(ChatProvider p) {
    Message msg = Message(
        msg: msgCont.text,
        fileUrl: "",
        receiverId: receiverUser.email,
        type: MessageTypeEnums.text.index,
        senderId: AppUser.user.email,
        roomId: room.roomId,
        seen: false,
        sentAt: Timestamp.now());

    return GestureDetector(
      onTap: () {
        p.sendMessage(msg: msg);
        msgCont.clear();
      },
      child: Container(
        width: 45.w,
        height: 46.h,
        padding: EdgeInsets.all(12.0.sp),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sp),
            color: AppConfig.colors.themeColor),
        child: Image.asset(AppConfig.images.chatMsgIcon,
            color: AppConfig.colors.whiteColor),
      ),
    );
  }

  Widget buildListMessage(ChatProvider p) {
    return StreamBuilder(
      stream: p.buildListStream(room.roomId),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: customLoader());
        } else if (snapshot.data!.docs.isEmpty) {
          // controller.onSendMessage(
          //     "Hi 👋", MessageTypeEnums.text, roomId);
          return Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(12.sp),
              child: Text(
                "Start the conversation by sending a message",
                style: latoBold.copyWith(
                    fontSize: 12.sp, color: Color(0xffD9D4D5)),
              ),
            ),
          );
        } else {
          // controller.listMessage = snapshot.data.docs;
          List<Message> msgs = [];
          for (var element in snapshot.data!.docs) {
            msgs.add(Message.fromJson(element.data()));
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10.0.sp),
            itemBuilder: (context, index) =>
                buildMessageItem(index, msgs[index]),
            itemCount: snapshot.data!.docs.length,
            reverse: true,
            controller: p.listScrollController,
          );
        }
      },
    );
  }

  Widget buildMessageItem(int index, Message message) {
    int messageType = message.type;
    bool isMyMessage = message.senderId == AppUser.user.email;
    // Right (my message)
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment:
          isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (isMyMessage) messageTimeAndSeen(message, isMyMessage),
        messageCard(messageType, message, isMyMessage),
        if (!isMyMessage) messageTimeAndSeen(message, isMyMessage),
      ],
    );
  }

  Widget messageCard(int messageType, Message message, bool isMyMessage) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isMyMessage ? 8.sp : 0),
          bottomRight: Radius.circular(isMyMessage ? 0 : 8.sp),
          topRight: Radius.circular(8.sp),
          bottomLeft: Radius.circular(8.sp),
        ),
        color: isMyMessage ? AppConfig.colors.themeColor : Colors.white,
        border: Border.all(
            color:
                isMyMessage ? AppConfig.colors.themeColor : Color(0xffD9D4D5),
            width: 1),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: Get.width * 0.6),
        child: Padding(
          padding: EdgeInsets.all(8.sp),
          child: messageType == MessageTypeEnums.text.index
              ? textMessage(message, isMyMessage)
              : messageType == MessageTypeEnums.image.index
                  ? imageMessage(message)
                  : messageType == MessageTypeEnums.file.index ||
                          messageType == MessageTypeEnums.pdf.index
                      ? fileMessage(message, isMyMessage)
                      : Text(message.msg),
        ),
      ),
    );
  }

  Widget textMessage(Message msg, bool isMyMessage) {
    return Text(
      msg.msg,
      textAlign: TextAlign.left,
      style: latoRegular.copyWith(
        fontSize: 14.sp,
        color: isMyMessage
            ? AppConfig.colors.whiteColor
            : AppConfig.colors.secondaryThemeColor,
      ),
    );
  }

  Widget imageMessage(Message msg) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.sp),
        child: CachedNetworkImage(
          imageUrl: msg.fileUrl,
          height: 125.h,
          width: 257.w,
          fit: BoxFit.cover,
        ));
  }

  Widget fileMessage(Message msg, bool isMyMessage) {
    return GestureDetector(
      onTap: () {
        print("tab");
        if (msg.type == MessageTypeEnums.pdf.index) {
          print("pdf");
          Get.to(DocumentViewerChat(isPDF: true, doc: msg.fileUrl,));
        } else {
          Get.to(DocumentViewerChat(isPDF: false, doc: msg.fileUrl,));
        }
      },
      child: Container(
          margin: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppConfig.images.file,
                  width: 15.sp,
                  height: 15.sp,
                  color: isMyMessage
                      ? AppConfig.colors.whiteColor
                      : AppConfig.colors.secondaryThemeColor),
              SizedBox(width: 10.w),
              Text(
                "Tab to open File !",
                textAlign: TextAlign.left,
                style: latoRegular.copyWith(
                  fontSize: 14.sp,
                  color: isMyMessage
                      ? AppConfig.colors.whiteColor
                      : AppConfig.colors.secondaryThemeColor,
                ),
              ),
            ],
          )),
    );
  }

  Widget messageTimeAndSeen(Message msg, bool isMyMessage) {
    return Padding(
      padding: EdgeInsets.only(
          right: isMyMessage ? 22.sp : 0, left: isMyMessage ? 0 : 22.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isMyMessage)
            Padding(
              padding: EdgeInsets.only(right: 6.sp),
              child: Icon(Icons.done_all,
                  size: 11.sp,
                  color: msg.seen
                      ? AppConfig.colors.themeColor
                      : AppConfig.colors.secondaryThemeColor),
            ),
          Text(
            DateFormat('hh:mm a').format(msg.sentAt.toDate()),
            style: TextStyle(
                color: AppConfig.colors.secondaryThemeColor, fontSize: 10.sp),
          ),
          if (!isMyMessage)
            Padding(
              padding: EdgeInsets.only(left: 6.sp),
              child: Icon(Icons.done_all,
                  size: 11.sp,
                  color: msg.seen
                      ? AppConfig.colors.themeColor
                      : AppConfig.colors.secondaryThemeColor),
            ),
        ],
      ),
    );
  }

  ImagePicker picker = ImagePicker();

  _imgFromGallery(ChatProvider p) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      sendFile(image, p, MessageTypeEnums.image.index);
    }
  }

  _fileFromPhone(ChatProvider p) async {
    MessageTypeEnums fileType = MessageTypeEnums.file;
    PlatformFile? pickedFile;

    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      pickedFile = result.files.first;
      if (isPDF(pickedFile.path!)) {
        print("pdf");
        fileType = MessageTypeEnums.pdf;
      } else {
        fileType = MessageTypeEnums.file;
      }
      final file = File(pickedFile.path!);
      sendFile(file, p, fileType.index);
    } else {
      return;
    }
  }

  bool isPDF(String path) {
    final mimeType = lookupMimeType(path);
    return mimeType!.startsWith('application/pdf');
  }

  _imgFromCamera(ChatProvider p) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      sendFile(image, p, MessageTypeEnums.image.index);
    }
  }

//send Media Message
  void sendFile(File chatFile, ChatProvider p, int msgType) async {
    String url = await p.uploadFile(chatFile);
    Message msg = Message(
        msg: "",
        fileUrl: url,
        receiverId: receiverUser.email,
        type: msgType,
        senderId: AppUser.user.email,
        roomId: room.roomId,
        seen: false,
        sentAt: Timestamp.now());
    p.sendMessage(msg: msg);
  }

  Widget trailing = IconButton(
    icon: const Icon(
      Icons.more_vert,
      color: Colors.white,
      size: 18,
    ),
    onPressed: () {},
  );

  void readAllMessage() {
    streamSubscription = FBCollections.chats
        .where("room_id", isEqualTo: room.roomId)
        .where("sender_id", isEqualTo: receiverUser.email)
        .where("seen", isEqualTo: false)
        .snapshots()
        .listen((value) {
      for (var element in value.docs) {
        if (kDebugMode) {
          print(element.id);
        }
        FBCollections.chats
            .doc(element.id)
            .update({'seen': true}).then((value) {
          if (kDebugMode) {
            print('\nSeen : : : : updated\n');
          }
        });
      }
    });
  }

  setSeenTrue() {
    readAllMessage();
  }
}
