import 'package:cloud_firestore/cloud_firestore.dart';

class Professions {
  late String id;
  late String title;
  late Timestamp createdAt;
  late String image;
  late String mapIcons;

  Professions({required this.id, required this.title,required this.createdAt,required this.image,required this.mapIcons});

  Professions.fromJson(dynamic json) {
    createdAt = json["created_at"];
    title = json["title"];
    id = json["id"];
    image = json["image"];
    mapIcons = json["mapIcons"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["created_at"] = createdAt;
    map["title"] = title;
    map["id"] = id;
    map["image"] = image;
    map["mapIcons"] = mapIcons;
    return map;
  }
}