import 'package:cloud_firestore/cloud_firestore.dart';

class DisableDates {
  late String id;
  late String proId;
  late Timestamp disableDate;
  late bool isDisable;

  DisableDates({required this.id, required this.proId, required this.disableDate, required this.isDisable});

  DisableDates.fromJson(dynamic json) {
    id = json["id"];
    proId = json["proId"];
    disableDate = json["disableDate"];
    isDisable = json["isDisable"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["proId"] = proId;
    map["disableDate"] = disableDate;
    map["isDisable"] = isDisable;
    return map;
  }


}