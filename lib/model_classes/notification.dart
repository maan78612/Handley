import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_pro/model_classes/booking_model.dart';

class NotificationModal {
  late String receiver;
  late String sender;
  late Timestamp createdAt;
  late String title;
  late String body;
  late String id;
  BookingModel? bookingData;
  late int notificationTypeStatus;

  // NotificationType? notificationType;
  late bool isSeen;

  NotificationModal(
      {required this.receiver,
      required this.sender,
      required this.createdAt,
      required this.title,
      required this.body,
      required this.id,
      required this.isSeen,
      // this.notificationType,
      required this.notificationTypeStatus,
      this.bookingData});

  NotificationModal.fromJson(dynamic json) {
    receiver = json["receiver"];
    sender = json["sender"];
    createdAt = json["created_at"];
    title = json["title"];
    body = json["body"];
    id = json["id"];
    notificationTypeStatus = json["notificationTypeStatus"];
    isSeen = json["isSeen"] ?? false;
    if (notificationTypeStatus == NotificationType.booking.index) {
      bookingData = (json["bookingData"] != null ? BookingModel.fromJson(json["bookingData"]) : null);
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["receiver"] = receiver;
    map["sender"] = sender;
    map["created_at"] = createdAt;
    map["title"] = title;
    map["body"] = body;
    map["id"] = id;
    map["notificationTypeStatus"] = notificationTypeStatus;
    map["isSeen"] = isSeen;
    if (notificationTypeStatus == NotificationType.booking.index) {
      map["bookingData"] = bookingData!.toJson();
    }
    return map;
  }
}

enum NotificationType {
  booking,
  payment,
  others,
}
