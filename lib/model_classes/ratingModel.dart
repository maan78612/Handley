import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  Timestamp? ratingDate;
  double? rating;
  String? review;

  RatingModel({required this.rating, required this.ratingDate, required this.review});

  RatingModel.fromJson(dynamic json) {
    ratingDate = json['ratingDate'];
    rating = json['rating'];
    review = json['review'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ratingDate'] = ratingDate;
    data['rating'] = rating;
    data['review'] = review;

    return data;
  }

  Map<String, dynamic> setBookingStatusJson(int bookingStatus) {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['booking_status'] = bookingStatus;
    return data;
  }
}
