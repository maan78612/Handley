import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utilities/app_utility.dart';
import 'local_notification_service.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  if (kDebugMode) {
    print('Handling a background message ${message.messageId}');
  }
}

// Crude counter to make messages unique
int _messageCount = 0;

/// Renders the example application.
class FBMessaging extends StatefulWidget {
  final Widget page;
  final BuildContext context;

  const FBMessaging({Key? key, required this.page, required this.context})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _Application();
}

class _Application extends State<FBMessaging> {
  // @override
  // void didChangeDependencies() {
  //   onInit(widget.context);
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onInit(widget.context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.page;
  }

  Future<void> onInit(BuildContext context) async {
    // await getFcmToken();
    registerNotification();
    /*   LocalNotificationService.initialize(context);
    //  1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        if (kDebugMode) {
          print(
              "FirebaseMessaging.instance.getInitialMessage [APP TERMINATED] ${message?.notification?.title}");
        }

        if (message != null) {
          if (kDebugMode) {
            print("onInit msg when terminated: $message");
          }
           // When we click on notification it send us to chat screen
          Get.offAll(DashBoard(index: 1));
        }
      },
    );

    // 2. This method only call when App in foreground it mean app must be opened
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Get Notification when app open');
        print('Message data: ${message.data}');
      }
       // Firebase not display notification snackBar in foreground So we need to show it here  by calling [createAndDisplayNotification]
       // One we created channel in [createAndDisplayNotification] there is no need to call on background and  termination state Firebase handle it
      LocalNotificationService.createAndDisplayNotification(message);
    });

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("APP CLOSE BUT NOT TERMINATED");
      }

      Get.offAll(DashBoard(index: 1));
    });*/
  }

  void registerNotification() async {
    // 3 this helps to take the user permissions
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      /* If you want to show notification and banner when app is open [ForeGround]*/
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        // Parse the message received
        print("msg received ");
        print("${message.notification!.title}");
        print("${message.notification!.body}");
        print("${message.data}");



      });
      pushNotificationOnTermination();
      pushNotificationOnBackGround();
    } else {
      print('User declined or has not accepted permission');
    }
  }

  pushNotificationOnTermination() async {
    await FirebaseMessaging.instance.getInitialMessage();
  }

  pushNotificationOnBackGround() async {
    // For handling notification when the app is in background
    // but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("msg received background");
    });
  }

  getFcmToken() {
    FirebaseMessaging.instance.getToken().then((token) {
      if (kDebugMode) {
        print("fcm =  $token");
      }
      AppUtility.freshFCM = token!;
    });
  }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });

  String? title;
  String? body;
}
