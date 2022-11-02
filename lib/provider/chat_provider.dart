import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_pro/chat_box/services/chat_services.dart';
import 'package:social_pro/chat_box/ui/conversation.dart';
import 'package:social_pro/model_classes/chat_room_model.dart';
import 'package:social_pro/model_classes/message.dart';
import 'package:social_pro/model_classes/user_data.dart';

import 'package:social_pro/utilities/show_message.dart';

class ChatProvider with ChangeNotifier {
  final ChatServices _services = CSs();
  final ScrollController listScrollController = ScrollController();
  bool isLoading = false;
  StreamSubscription? _chatSub;
  List<ChatRoom> chatRooms = [];
  TextEditingController chatTextEditingController = TextEditingController();

  // List<ChatRoom> readRooms = [];

  Stream<QuerySnapshot<Object?>> buildListStream(roomId) {
    return _services.buildConversationList(roomId: roomId);
  }

  Stream<QuerySnapshot> getUnreadMsgs({required String roomId}) {
    return _services.chatUnreadMessages(roomId);
  }

  //create Chat
  Future<void> initiateChat(UserData? peerUser) async {
    if (kDebugMode) {
      print("INITIATE CHAT");
    }
    startLoader();
    if (peerUser != null) {
      ChatRoom? isCreated = isAlreadyCreated(peerUser.email);
      if (isCreated != null) {
        stopLoader();
        if (kDebugMode) {
          print("room found======");
        }
        return Get.to(Conversation(
          room: isCreated,
          userData: peerUser,
        ));
      } else {
        if (kDebugMode) {
          print("creating new======");
        }
        ChatRoom room = ChatRoom(
            unreadCount: 1,
            jobId: "",
            createdBy: AppUser.user.email,
            users: [AppUser.user.email, peerUser.email],
            roomId: "",
            createdAt: Timestamp.now());
        startLoader();
        ChatRoom cRoom = await _services.createChatRoom(room: room);
        stopLoader();
        await fetchMyChatRooms();
        Get.to(Conversation(
          room: cRoom,
          userData: peerUser,
        ));
      }
    } else {
      ShowMessage.toast(
        "No people selected to add",
      );
    }
  }

  //check if already created chatroom
  ChatRoom? isAlreadyCreated(String email) {
    print("here email is $email");
    print("here chat rooms are is ${chatRooms.length}.");

    // check if chatRoom of these members already exits to avoid redundancy
    ChatRoom? room;
    List<ChatRoom> rooms = [];
    rooms.addAll(chatRooms);
    print("here  rooms are is ${rooms.length}.");
    if (rooms.isEmpty) {
      room = null;
      return room;
    }
    print("here 2 rooms are is ${rooms.length}.");
    for (int i = 0; i < rooms.length; i++) {
      ChatRoom element = rooms[i];
      if (element.users.contains(AppUser.user.email) &&
          element.users.contains(email)) {
        room = element;
        break;
      }
    }
    return room;
  }

  // Future<UserData> getUser(String email) async {
  //   //fetch user detail to show the name
  //
  //   UserData user = await fs.getUserById(email);
  //   return user;
  // }

  fetchMyChatRooms() async {
    print(" start fetching chat rooms");
    print("${AppUser.user.email}");
    //Loads all tasks that are assigned and are currently in progress
    var value = await _services.getAllChatRooms();

    if (_chatSub == null) {
      _chatSub ??= value.listen((event) {
        chatRooms = event;
        chatRooms = chatRooms
            .where((element) => element.users.contains(AppUser.user.email))
            .toList();
        if (kDebugMode) {
          print("total rooms = ${chatRooms.length}");
        }
      });


    }


  }

  Future<String> uploadFile(File file) async {
    startLoader();
    String url = await _services.uploadFile(file: file);
    stopLoader();
    return url;
  }

  void sendMessage({required Message msg}) async {
    await _services.sendMessage(msg: msg);
  }

  Stream<QuerySnapshot> allUnreadMessages() {
    CollectionReference colRef = FirebaseFirestore.instance.collection("chats");
    Query query = colRef.where("receiver_id", isEqualTo: AppUser.user.email);
    query = query.where("seen", isEqualTo: false);
    // notifyListeners();

    return query.snapshots();
  }

  /* Search bar */

  String searchFieldChat = "";

  void search() {
    searchFieldChat = chatTextEditingController.text.toLowerCase();
    if (kDebugMode) {
      print("search value is $searchFieldChat");
    }
    notifyListeners();
  }

  void onEditComplete() {
    if (kDebugMode) {
      print("editing complete");
    }
    FocusManager.instance.primaryFocus?.unfocus();

    notifyListeners();
  }

  void clearSearchText() {
    FocusManager.instance.primaryFocus?.unfocus();
    searchFieldChat = "";
    chatTextEditingController.clear();
    notifyListeners();
  }

  startLoader() {
    print("===========loading start===========");
    isLoading = true;
    notifyListeners();
  }

  stopLoader() {
    print("===========loading ends===========");
    isLoading = false;
    notifyListeners();
  }

  void onDispose() {
    _chatSub?.cancel();
    _chatSub=null;
    notifyListeners();
  }
}
