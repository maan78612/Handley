import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_pro/constants/firebase_collections.dart';
import 'package:social_pro/model_classes/booking_model.dart';
import 'package:social_pro/model_classes/notification.dart';
import 'package:social_pro/model_classes/ratingModel.dart';
import 'package:social_pro/model_classes/saved_addresses.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/notification_box/notification_sender.dart';

import 'package:social_pro/utilities/enums.dart';

class AppServices {
  /*  ===================Booking Services ===================*/

  static Stream<List<BookingModel>> getUserBookings() {
    var ref = FBCollections.bookings.snapshots().asBroadcastStream();
    var x = ref.map((event) =>
        event.docs.map((e) => BookingModel.fromJson(e.data())).toList());
    return x;
  }

  static setUserBooking(BookingModel booking) async {
    await FBCollections.bookings.doc(booking.bookingID).set(booking.toJson());
    sendNotification(
        msg: 'you got booking request from ${AppUser.user.firstName}',
        title: 'Booking Request',
        receiverID: booking.proId!,
        notificationTypeStatus: NotificationType.booking,
        bookingData: booking);
  }

  static acceptUserBooking(BookingModel booking) async {
    await FBCollections.bookings
        .doc(booking.bookingID)
        .update(booking.setBookingStatusJson(BookingType.active.index));
    booking.bookingStatus = BookingType.active.index;
    sendNotification(
        msg:
            'your proposal for booking has been accepted by ${AppUser.user.firstName}',
        title: 'Booking Accepted',
        receiverID: booking.customerId!,
        notificationTypeStatus: NotificationType.booking,
        bookingData: booking);
  }

  static completeUserBooking(BookingModel booking) async {
    booking.finishedAt = Timestamp.now();
    await FBCollections.bookings
        .doc(booking.bookingID)
        .update(booking.setBookingStatusJson(BookingType.complete.index));

    booking.bookingStatus = BookingType.complete.index;
    sendNotification(
        msg: 'you got job has been completed by ${AppUser.user.firstName}',
        title: 'Service Completed',
        receiverID: booking.proId!,
        notificationTypeStatus: NotificationType.booking,
        bookingData: booking);
  }

  static cancelUserBooking(BookingModel booking) async {
    await FBCollections.bookings
        .doc(booking.bookingID)
        .update(booking.setBookingStatusJson(BookingType.cancel.index));
    booking.bookingStatus = BookingType.cancel.index;
    sendNotification(
        msg:
            'your proposal for booking has been cancelled by ${AppUser.user.firstName}, Please Book for another time',
        title: 'Booking Cancel',
        receiverID: AppUser.user.userType == UserType.professional
            ? booking.customerId!
            : booking.proId!,
        notificationTypeStatus: NotificationType.booking,
        bookingData: booking);
  }

  static updateProfessionalInfo(UserData user) async {
    await FBCollections.users.doc(user.email).update(user.toJson());
  }

  static Future<List<BookingModel>> getProfessionalBookings(
      String proID) async {
    var ref = await FBCollections.bookings.get();

    List<BookingModel> professionalBookings = [];
    List<BookingModel> temp =
        ref.docs.map((doc) => BookingModel.fromJson(doc.data())).toList();

    /* filtering bookings of specific user and with user type of current*/
    professionalBookings = temp
        .where((element) =>
            element.proId == proID && element.bookingType == BookingType.active)
        .toList();
    return professionalBookings;
  }

  /*  ===================Rating Services ===================*/
  static setRating(BookingModel booking, RatingModel ratingModel) async {
    await FBCollections.bookings
        .doc(booking.bookingID)
        .update(booking.setRating(ratingModel));
  }

  /*  ===================Notification Services ===================*/

  static Stream<List<NotificationModal>> getUserNotifications() {
    var ref = FBCollections.notifications.snapshots().asBroadcastStream();
    var x = ref.map((event) =>
        event.docs.map((e) => NotificationModal.fromJson(e.data())).toList());
    return x;
  }

  static Future<void> sendNotification({
    required String receiverID,
    required String msg,
    required String title,
    required NotificationType notificationTypeStatus,
    BookingModel? bookingData,
  }) async {
    FBNotification fbNotification = FBNotification();
    NotificationModal bookingNotification = NotificationModal(
      receiver: receiverID,
      id: Timestamp.now().millisecondsSinceEpoch.toString(),
      sender: AppUser.user.email,
      createdAt: Timestamp.now(),
      title: title,
      body: msg,
      isSeen: false,
      notificationTypeStatus: notificationTypeStatus.index,
      bookingData: bookingData,
    );

    await fbNotification.notify(bookingNotification,
        sendInApp: true, sendPush: true);
  }

  static deleteUserNotification(NotificationModal notify) async {
    await FBCollections.notifications.doc(notify.id).delete();
  }

  /*  ===================Address Services ===================*/
  static Stream<List<SavedAddressesModel>> getUserSavedAddress() {
    var ref = FBCollections.savedAddress.snapshots().asBroadcastStream();
    Stream<List<SavedAddressesModel>> x = ref.map((event) => event.docs
        .map((e) => SavedAddressesModel.fromJson(e.data()))
        .where((element) => element.userID == AppUser.user.email)
        .toList());
    return x;
  }

  static setUserAddress(SavedAddressesModel address) async {
    await FBCollections.savedAddress
        .doc(address.addressID)
        .set(address.toJson());
  }

  static deleteUserAddress(SavedAddressesModel address) async {
    print(address.addressID);
    await FBCollections.savedAddress.doc(address.addressID).delete();
  }

  static updateUserAddressID(String? addressID) async {
    await FBCollections.users
        .doc(AppUser.user.email)
        .update(AppUser.user.setAddressID(addressID));
  }
}
