import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/model_classes/disableDates.dart';
import 'package:social_pro/model_classes/location_model.dart';
import 'package:social_pro/model_classes/professions.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/utilities/enums.dart';



class UserData {
  late String imageUrl;
   String? doc1Url;
    String? doc2Url;
  late Timestamp createdAt;
  late String address;
  String? description;
  late String firstName;
  late String lastName;
  late String email;
  late double distanceToFindUser;
  late String fcm;
  late int role;
  int? experience;
   Location? location;
  Professions? profession;
  String? professionID;
  late UserType userType;
  double? rating;
  int? numberOfJobs;
  int? ratingCount;
  double? satisfactionPercentage;
  int? gender;
  Timestamp? dob;
  String? selectedAddressID;
  late List<DisableDates> disableDates;

  UserData({
    required this.createdAt,
    required this.description,
    required this.address,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.distanceToFindUser,
    required this.fcm,
    required this.location,
    required this.imageUrl,
    required this.doc2Url,
    required this.doc1Url,
    required this.userType,
    this.profession,
    this.professionID,
    required this.role,
    required this.satisfactionPercentage,
    required this.rating,
    required this.experience,
    required this.numberOfJobs,
    required this.ratingCount,
    this.gender,
    this.dob,
    this.selectedAddressID,
    required this.disableDates
  });

  UserData.fromJson(dynamic json) {
    imageUrl = json["image_url"];
    address = json["address"] ?? "";
    createdAt = json["created_at"];
    firstName = json["firstName"];
    lastName = json["lastName"];
    email = json["email"];
    fcm = json["fcm"];
    role = json["role"];
    gender = json["gender"];
    dob = json["dob"];
    selectedAddressID = json["selectedAddressID"];

    distanceToFindUser = double.parse(json["distance_to_find_user"].toString());
    location = (json["location"] != null
        ? Location.fromJson(json["location"])
        : null);

    switch (role) {
      case 0:
        userType = UserType.customer;
        break;

      case 1:
        userType = UserType.professional;
        break;
      default:
        userType = UserType.customer;
    }
    if (userType == UserType.professional) {
      numberOfJobs = json["numberOfJobs"];
      doc1Url = json["doc1Url"];
      doc2Url = json["doc2Url"];
      ratingCount = json["ratingCount"];
      rating = double.parse(json["rating"].toString());
      experience = json["experience"];
      satisfactionPercentage =    double.parse(json["satisfactionPercentage"].toString());
      description = json["description"];
      professionID = json["professionID"];
      profession=Provider.of<AuthProvider>(Get.context!,listen: false).professionList.where((element) => element.id==professionID).first;

    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["role"] = role;
    map["image_url"] = imageUrl;
    map["address"] = address;
    map["created_at"] = createdAt;
    map["firstName"] = firstName;
    map["lastName"] = lastName;
    map["email"] = email;
    map["fcm"] = fcm;
    map["gender"] = gender;
    map["dob"] = dob;
    map["selectedAddressID"] = selectedAddressID;
    map["distance_to_find_user"] = distanceToFindUser;
    if(location!=null){
      map["location"] = location!.toJson();
    }else{
      map["location"]=null;
    }

    if (role == 1) {
      map["description"] = description;
      map["doc1Url"] = doc1Url;
      map["doc2Url"] = doc2Url;
      map["numberOfJobs"] = numberOfJobs;
      map["ratingCount"] = ratingCount;
      map["satisfactionPercentage"] = satisfactionPercentage;
      map["rating"] = rating;
      map["experience"] = experience;
      map["profession"] = profession?.toJson();
      map["professionID"] = professionID;
    }
    return map;
  }

  Map<String, dynamic> setAddressID(String? addressID) {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['selectedAddressID'] = addressID;

    return data;
  }
}

class AppUser {
  static late UserData user;
}


