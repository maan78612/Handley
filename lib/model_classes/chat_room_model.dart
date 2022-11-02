import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  late int unreadCount;
  late String jobId;
  late Timestamp createdAt;
  late String createdBy;
  late String roomId;
  late List<String> users;

  ChatRoom(
      {required this.unreadCount,
      required this.jobId,
      required this.createdAt,
      required this.createdBy,
      required this.roomId,
      required this.users});

  ChatRoom.fromJson(dynamic json) {
    unreadCount = json["unread_count"];
    jobId = json["job_id"];
    roomId = json["room_id"];
    createdAt = json["created_at"];
    createdBy = json["created_by"];
    users = json["users"] != null ? json["users"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["unread_count"] = unreadCount;
    map["job_id"] = jobId;
    map["created_at"] = createdAt;
    map["room_id"] = roomId;
    map["created_by"] = createdBy;
    map["users"] = users;
    return map;
  }
}
