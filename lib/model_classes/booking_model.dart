import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_pro/model_classes/ratingModel.dart';
import 'package:social_pro/model_classes/saved_addresses.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/utilities/enums.dart';

class BookingModel {
  String? customerId;
  String? proId;
  Timestamp? bookingDate;
  int? bookingStatus;
  String? bookingID;
  BookingType? bookingType;
  UserData? userData;
  RatingModel? rating;
  Timestamp? finishedAt;
  late SavedAddressesModel bookingAddress;

  BookingModel(
      {this.customerId,
      this.proId,
      this.bookingDate,
      this.bookingStatus,
      this.bookingType,
      this.bookingID,
      this.userData,
      this.rating,
      this.finishedAt,
      required this.bookingAddress});

  BookingModel.fromJson(dynamic json) {
    customerId = json['customer_id'];
    proId = json['pro_id'];
    bookingDate = json['booking_date'];
    finishedAt = json['finishedAt'];
    bookingStatus = json['booking_status'];
    bookingID = json['bookingID'];
    rating =
        (json["rating"] != null ? RatingModel.fromJson(json["rating"]) : null);
    bookingAddress = (json["bookingAddress"] != null
        ? SavedAddressesModel.fromJson(json["bookingAddress"])
        : null)!;

    switch (bookingStatus) {
      case 0:
        bookingType = BookingType.complete;
        break;

      case 1:
        bookingType = BookingType.pending;
        break;
      case 2:
        bookingType = BookingType.active;
        break;
      case 3:
        bookingType = BookingType.cancel;
        break;
      default:
        bookingType = BookingType.pending;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = customerId;
    data['pro_id'] = proId;
    data['booking_date'] = bookingDate;
    data['finishedAt'] = finishedAt;
    data['booking_status'] = bookingStatus;
    data['bookingID'] = bookingID;
    data['rating'] = rating;
    data['bookingAddress'] = bookingAddress.toJson();
    return data;
  }

  Map<String, dynamic> setBookingStatusJson(int bookingStatus) {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['booking_status'] = bookingStatus;
    data['finishedAt'] = finishedAt;
    return data;
  }

  Map<String, dynamic> setRating(RatingModel ratingModel) {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['rating'] = ratingModel.toJson();
    return data;
  }
}
