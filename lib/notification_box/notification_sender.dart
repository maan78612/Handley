import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:social_pro/chat_box/services/chat_services.dart';
import 'package:social_pro/constants/firebase_collections.dart';
import 'package:social_pro/model_classes/notification.dart';
import 'package:social_pro/model_classes/user_data.dart';



class FBNotification {
  Future<void> notify(NotificationModal notification,
      {bool sendInApp = false, bool sendPush = false}) async {
    UserData? user = await CSs().getUserById(notification.receiver);
    print("Notification receiver data => ${user?.toJson()}");
    if (sendInApp) {
      await InAppNotifications.sendNotification(notification);
    }
    if (sendPush) {
      String? fcm = user?.fcm;
      if (kDebugMode) {
        print("receiver fcm is $fcm");
      }
      await PushNotification.sendNotification(fcm!, notification);
    }
  }
}

class InAppNotifications {
  static Future<void> sendNotification(NotificationModal notification) async {
    String id = Timestamp.now().millisecondsSinceEpoch.toString();
    notification.id = id;
    await FBCollections.notifications
        .doc(notification.id)
        .set(notification.toJson())
        .then((value) {
      if (kDebugMode) {
        print('notification added');
      }
    });
  }
}

class PushNotification {
  static Future<void> sendNotification(
    String fcmToken,
    NotificationModal notification,
  ) async {
    Map<String, dynamic> notif = {
      'body': notification.body,
      'title': notification.title,
      // 'type': notification.type
    };
    String body = jsonEncode(
      <String, dynamic>{
        'notification': notif,
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '5',
          "sound": "default",
          'status': 'done'
        },
        'to': fcmToken,
      },
    );
    var response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'key=AAAAS1SvfAU:APA91bGCYMUipki8W9aZI-az7KvtDDOcF93QKWFVJwuLRiItPyP8W3fBJ2wErBsOrIps-BGWx2yR8sp1w3LwFohNRwj0V9UDQvW0ecDtUft_7iF18yEC7Zg7yvSppFTpXCMfV9F0l_en',
            },
            body: body);
    if (kDebugMode) {
      print(body);
      print(response.statusCode);
      print(response.body);
    }
  }
}
