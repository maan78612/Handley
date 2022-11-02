// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
//
// import '../Provider/appProvider.dart';
// import '../UI/dashBoard/dashBoard.dart';
//
// class LocalNotificationService {
//   /// Initialize the [FlutterLocalNotificationsPlugin] package.
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   static void initialize(BuildContext context) {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     IOSInitializationSettings initializationSettingsIOS =
//         const IOSInitializationSettings(
//       requestSoundPermission: true,
//       requestBadgePermission: true,
//       requestAlertPermission: true,
//     );
//
//     InitializationSettings initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid,
//         iOS: initializationSettingsIOS,
//         macOS: null);
//
//     _notificationsPlugin.initialize(
//       initializationSettings,
//       onSelectNotification: (String? id) async {
//         if (kDebugMode) {
//           print("onSelectNotification flutter local notification");
//           print(id);
//         }
//         if (id!.isNotEmpty) {
//           if (kDebugMode) {
//             print("Router Value1234 $id");
//           }
//           Get.offAll(DashBoard(index: 1));
//
//         }
//       },
//     );
//   }
//
//   static void createAndDisplayNotification(RemoteMessage message) async {
//     /*
//     2 thing happening here created channel and show heads up notification on foreground
//     Heads up notification (snackBar) automatically show on background and termination state once channel created
//     So there is no need to call that function on [getInitialMessage] termination and [onMessageOpenedApp] background
//     */
//     if (kDebugMode) {
//       print("call: createAndDisplayNotification ${message.notification!.title} ");
//     }
//     try {
//       final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//       NotificationDetails notificationDetails = NotificationDetails(
//           android: AndroidNotificationDetails(
//             channel.id,
//             channel.name,
//             channelDescription: channel.description,
//             importance: channel.importance,
//             priority: Priority.high,
//             playSound: true,
//             // TODO add a proper drawable resource to android, for now using
//             //      one that already exists in example app.
//             icon: 'launch_background',
//           ),
//           iOS: const IOSNotificationDetails(
//             presentAlert: true,
//             // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
//             presentBadge: true,
//             // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
//             presentSound:
//                 true, // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
//           ));
//       await _notificationsPlugin.show(
//         id,
//         message.notification!.title,
//         message.notification!.body,
//         notificationDetails,
//         payload: message.data['_id'],
//       );
//     } on Exception catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }
//
//   // Create a [AndroidNotificationChannel] for heads up notifications
//   static const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     description: 'This channel is used for important notifications.',
//     // description
//     importance: Importance.max,
//   );
// }



/*
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:rxdart/subjects.dart';

class NotificationService {
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String> behaviorSubject = BehaviorSubject();

  Future<void> initializePlatformNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
  }

  void selectNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      behaviorSubject.add(payload);
    }
  }

  Future<NotificationDetails> _notificationDetails() async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      // groupKey: 'com.example.flutter_push_notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      ticker: 'ticker',
      icon: 'launch_background',
    );

    IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails(threadIdentifier: "thread1");

    final details = await _localNotifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      behaviorSubject.add(details.payload!);
    }
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

    return platformChannelSpecifics;
  }

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final platformChannelSpecifics = await _notificationDetails();
    await _localNotifications.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}*/
