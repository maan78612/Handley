

import 'package:social_pro/model_classes/location_model.dart';

class SavedAddressesModel {
  late String userID;
  late String addressID;
  late String addressName;
  late String buildingName;
  late String apartmentNum;
  late int floorNum;
  late String additionalDirection;
  late Location location;
  late String address;

  SavedAddressesModel(
      {required this.userID,
      required this.addressID,
      required this.addressName,
      required this.buildingName,
      required this.apartmentNum,
      required this.additionalDirection,
      required this.floorNum,
      required this.address,
      required this.location});

  SavedAddressesModel.fromJson(dynamic json) {
    userID = json["userID"];
    addressID = json["addressID"];
    addressName = json["addressName"];
    buildingName = json["buildingName"];
    apartmentNum = json["apartmentNum"];
    floorNum = json["floorNum"];
    address = json["address"];
    additionalDirection = json["additionalDirection"];
    location = (json["location"] != null
        ? Location.fromJson(json["location"])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["userID"] = userID;
    map["addressID"] = addressID;
    map["addressName"] = addressName;
    map["buildingName"] = buildingName;
    map["apartmentNum"] = apartmentNum;
    map["floorNum"] = floorNum;
    map["additionalDirection"] = additionalDirection;
    map["address"] = address;

    map["location"] = location.toJson();

    return map;
  }
}
