import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:social_pro/Services/app_services.dart';
import 'package:social_pro/model_classes/booking_model.dart';
import 'package:social_pro/model_classes/location_from_ipa_model.dart';
import 'package:social_pro/model_classes/location_model.dart';
import 'package:social_pro/model_classes/saved_addresses.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/provider/chat_provider.dart';
import 'package:social_pro/chat_box/services/chat_services.dart';
import 'package:social_pro/constants/firebase_collections.dart';
import 'package:social_pro/model_classes/notification.dart';
import 'package:social_pro/model_classes/ratingModel.dart';
import 'package:social_pro/ui/more/saved_addresses/address_form_screen.dart';
import 'package:social_pro/utilities/api_functions.dart';
import 'package:social_pro/utilities/enums.dart';
import 'package:social_pro/utilities/location_service.dart';



class AppProvider extends ChangeNotifier {
  AuthProvider authProvider =
      Provider.of<AuthProvider>(Get.context!, listen: false);

  bool isLoading = false;
  int selectedDashBoardIndex = 0;

  void startLoader() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoader() {
    isLoading = false;
    notifyListeners();
  }

  /* DashBoard indexing*/
  void onDashboardTab(int index) {
    if (selectedDashBoardIndex != index) {
      selectedDashBoardIndex = index;
      bookingTabIndex = 0;

      if (kDebugMode) {
        print("selected index is $selectedDashBoardIndex");
      }
    }

    notifyListeners();
  }

  /* Set rating */
  double ratingValue = 0;

  void setRating(double rating) {
    ratingValue = rating;
    if (kDebugMode) {
      print("rating  is $ratingValue");
    }
    notifyListeners();
  }

  Future<void> submitRating(
      {required BookingModel booking,
      required RatingModel newRating,
      required UserData professional}) async {
    try {
      await AppServices.setRating(booking, newRating);
      if (professional.ratingCount == 0) {
        professional.rating = newRating.rating;
      } else {}
      professional.rating =
          (((professional.rating! * professional.ratingCount!) +
                  newRating.rating!) /
              (professional.ratingCount! + 1));
      professional.ratingCount = (professional.ratingCount! + 1);
      professional.satisfactionPercentage = ((professional.rating! * 100) / 5);

      await updateProfessional(professional: professional);
    } on Exception catch (e) {
      if (kDebugMode) {
        print("post booking error $e");
      }
    }

    notifyListeners();
  }

  Future<void> updateProfessional({required UserData professional}) async {
    if (kDebugMode) {
      print("UpdateProfessional");
    }

    try {
      await AppServices.updateProfessionalInfo(professional);
    } on Exception catch (e) {
      if (kDebugMode) {
        print("post booking error $e");
      }
    }

    notifyListeners();
  }

  /* Sorting and showing professionals*/

  int selectedRadioTileIndex = -1;

  void selectProfessionForSorting(
      {required String professionalID, required int tileIndex}) {
    authProvider.selectedProfessionalID = professionalID;
    selectedRadioTileIndex = tileIndex;

    if (kDebugMode) {
      print(
          "pressed radio tile number $selectedRadioTileIndex and its id is :${authProvider..selectedProfessionalID}");
    }

    notifyListeners();
  }

  /*================ Booking Module==========================*/

  StreamSubscription<List<UserData>>? bookingStream;

  List<BookingModel> userBookings = [];
  List<BookingModel> allBookings = [];

  List<BookingModel> userPreviousBookings = [];
  List<BookingModel> userPendingBookings = [];
  List<BookingModel> userActiveBookings = [];

  Future<void> fetchUserBookings() async {
    List<BookingModel> temp;
    var value = AppServices.getUserBookings();

    if (bookingStream == null) {
      userBookings = [];
      allBookings = [];
      value.listen((event) async {
        temp = event;

        userBookings = [];
        allBookings = [];
        for (var b in temp) {
          allBookings.add(b);
          if (AppUser.user.userType == UserType.professional &&
              b.proId == AppUser.user.email) {
            userBookings.add(b);
          } else if (AppUser.user.userType == UserType.customer &&
              b.customerId == AppUser.user.email) {
            userBookings.add(b);
          }
        }
        temp.clear();

        userPreviousBookings = userBookings
            .where((element) => element.bookingType == BookingType.complete || element.bookingType == BookingType.cancel)
            .toList();
        userPendingBookings = userBookings
            .where((element) => element.bookingType == BookingType.pending)
            .toList();
        userActiveBookings = userBookings
            .where((element) => element.bookingType == BookingType.active)
            .toList();
        if (kDebugMode) {
          print("total booking   ${allBookings.length}");
          print("total booking of user are  ${userBookings.length}");
          print("previous booking of user are  ${userPreviousBookings.length}");
          print("pending booking of user are  ${userPendingBookings.length}");
          print("current booking of user are  ${userActiveBookings.length}");
          /* We are fetching User data when booking status change in stream because we are also updating User data  in User Document */
          authProvider.appUserData =
              await authProvider.getUserFromDB(AppUser.user.email);

          if (authProvider.appUserData != null) {
            AppUser.user = authProvider.appUserData!;
          }

          differentiateRating();
        }
        notifyListeners();
      });
    }
  }

  Future<List<BookingModel>> fetchBookingOfProfessional(String proID) async {
    List<BookingModel> professionalBookings = [];
    startLoader();

    professionalBookings = await AppServices.getProfessionalBookings(proID);
    stopLoader();

    if (kDebugMode) {
      print(
          "length of  professions bookings are ${professionalBookings.length}");
    }
    notifyListeners();
    return professionalBookings;
  }

  Future<void> setBooking(BookingModel booking) async {
    if (kDebugMode) {
      print("booking is ${booking.toJson()}");
    }

    try {
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      booking.bookingID = id;
      await AppServices.setUserBooking(booking);
    } on Exception catch (e) {
      if (kDebugMode) {
        print("post booking error $e");
      }
    }
  }

  Future<void> completeBooking(BookingModel booking) async {
    if (kDebugMode) {
      print("booking finish");
    }

    try {
      await AppServices.completeUserBooking(booking);
    } on Exception catch (e) {
      if (kDebugMode) {
        print("post booking error $e");
      }
    }
  }

  Future<void> acceptBooking(BookingModel booking) async {
    if (kDebugMode) {
      print("booking accepted");
    }

    try {
      await AppServices.acceptUserBooking(booking);
    } on Exception catch (e) {
      if (kDebugMode) {
        print("post booking error $e");
      }
    }
  }

  Future<void> cancelBooking(BookingModel booking) async {
    if (kDebugMode) {
      print("booking deleted");
    }

    try {
      await AppServices.cancelUserBooking(booking);
    } on Exception catch (e) {
      if (kDebugMode) {
        print("post booking error $e");
      }
    }
  }

  startChat(String userID) async {
    var p = Provider.of<ChatProvider>(Get.context!, listen: false);
    startLoader();
    try {
      await fetchUser(userID);
      await p.initiateChat(user);
      stopLoader();
    } on Exception catch (e) {
      if (kDebugMode) {
        print("error on starting chat is $e");
      }
      stopLoader();
    }
    notifyListeners();
  }

  UserData? user;
  final ChatServices _chatServices = CSs();

  fetchUser(String userID) async {
    user = await _chatServices.getUserById(userID);
    debugPrint("user found: ${user?.toJson()}");
  }

  void onDispose() {
    bookingStream?.cancel();
    bookingStream = null;
    notificationStream?.cancel();
    notificationStream = null;
    notifyListeners();
  }

  /*=======================================================================*/
  /*==================================CHARTS===============================*/
  /*=======================================================================*/

  List<BookingModel> completedBookingList = [];
  List<BookingModel> ratedBookingsOfProfessional = [];

  void differentiateRating() {
    completedBookingList.clear();
    completedBookingList = userBookings
        .where((element) => element.bookingType == BookingType.complete)
        .toList();

    ratedBookingsOfProfessional.clear();
    for (var element in completedBookingList) {
      if (element.rating != null) {
        ratedBookingsOfProfessional.add(element);
      }
    }
    ratedBookingsOfProfessional = ratedBookingsOfProfessional.reversed.toList();
  }

/*  ===================Notifications ===================*/

  StreamSubscription<List<UserData>>? notificationStream;

  List<NotificationModal> userNotifications = [];
  bool isSeenNotification = false;

  Future<void> fetchUserNotifications() async {
    List<NotificationModal> temp;
    var value = AppServices.getUserNotifications();

    if (notificationStream == null) {
      userNotifications = [];
      value.listen((event) async {
        temp = event.where((b) => b.receiver == AppUser.user.email).toList();

        userNotifications = [];
        for (var b in temp) {
          userNotifications.add(b);
        }
        temp.clear();
        isSeenNotification = userNotifications
            .where((element) => element.isSeen != true)
            .isNotEmpty;
        if (kDebugMode) {
          print("total notifications of user are  ${userNotifications.length}");
        }
        notifyListeners();
      });
    }
  }

  Future<void> deleteNotification(NotificationModal notify, index) async {
    if (kDebugMode) {
      print("notification deleted");
    }
    startLoader();
    try {
      userNotifications.removeAt(index);
    } on Exception catch (e) {
      if (kDebugMode) {
        print("post booking error $e");
      }
    }
    stopLoader();
    notifyListeners();
  }

  Future<void> deleteAllNotifications() async {
    if (kDebugMode) {
      print("all notifications deleted");
    }

    startLoader();
    try {
      for (NotificationModal notification in userNotifications) {
        // print("Delete notification id ${notification.id}");
        await AppServices.deleteUserNotification(notification);
        // Future.delayed(Duration(seconds: 3), () async {
        //
        // });
      }
      // userNotifications=[];
    } on Exception catch (e) {
      if (kDebugMode) {
        print("all notifications deleted error $e");
      }
    }
    stopLoader();
    notifyListeners();
  }

  Future<void> makeAllNotificationRead() async {
    List<NotificationModal> unseenNotifications =
        userNotifications.where((element) => element.isSeen != true).toList();
    if (kDebugMode) {
      print("all notifications seen");
    }

    startLoader();
    try {
      for (var noti in unseenNotifications) {
        await FBCollections.notifications.doc(noti.id).update({
          'isSeen': true,
        });
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("post booking error $e");
      }
    }
    stopLoader();
    notifyListeners();
  }

  /* Professionals filter*/

  List<UserData> newlyAddedProfessional(List<UserData> professionalList) {
    List<UserData> filterList = [];
    professionalList.forEach((element) {
      final difference =
          DateTime.now().difference(element.createdAt.toDate()).inDays;
      print(difference);
      if (difference <= 15) {
        filterList.add(element);
      }
    });
    notifyListeners();
    return filterList;
  }

  List<UserData> topRatedProfessional(List<UserData> professionalList) {
    List<UserData> filterList = [];
    filterList =
        professionalList.where((element) => (element.rating!) >= 4.5).toList();
    notifyListeners();
    return filterList;
  }

  List<UserData> highlyExperiencedProfessional(
      List<UserData> professionalList) {
    List<UserData> filterList = [];
    filterList = professionalList
        .where((element) => (element.experience!) >= 5)
        .toList();
    notifyListeners();
    return filterList;
  }

  int bookingTabIndex = 0;

  void bookingTabStatusChanger(int index) {
    bookingTabIndex = index;
    print("on tab index is $bookingTabIndex");
    notifyListeners();
  }

/*=============================================================================*/
/*==============================ADDRESSES======================================*/
/*=============================================================================*/

  StreamSubscription<List<UserData>>? addressStream;

  ///////////Address Controllers////////////
  TextEditingController addressNameCont = TextEditingController();
  TextEditingController buildingNameCont = TextEditingController();
  TextEditingController apartmentNumCont = TextEditingController();
  TextEditingController floorNumCont = TextEditingController();
  TextEditingController additionalDirectionCont = TextEditingController();

  ///////////Address FocusNode////////////

  FocusNode addressNameNode = FocusNode();
  FocusNode buildingNameNode = FocusNode();
  FocusNode apartmentNumNode = FocusNode();
  FocusNode floorNumNode = FocusNode();
  FocusNode additionalDirectionNode = FocusNode();

  Location? selectedAddressLocation;
  String? selectedAddressLocationAddress;

  List<SavedAddressesModel> userSavedAddress = [];

  SavedAddressesModel? selectedAddress;

  /////////////////////// GET ADDRESSES //////////////////////////////
  Future<void> fetchUserSavedAddress() async {
    var value = AppServices.getUserSavedAddress();
    selectedAddress = null;
    if (addressStream == null) {
      userSavedAddress = [];
      value.listen((event) async {
        userSavedAddress = event;

        if (kDebugMode) {
          print("total saved address of user are  ${userSavedAddress.length}");
          print(AppUser.user.selectedAddressID);
        }
        selectAddress();
        notifyListeners();
      });
    }
  }

  Future<void> onTabAddNewAddress() async {
    print(AppUser.user.location);
    Location? location;
    if (AppUser.user.location != null) {
      location = Location(
          lat: AppUser.user.location!.lat, long: AppUser.user.location!.long);
    } else {
      // call api for long and lat

      LocationApiFromIPA? data = await getLocFromIpaAddress();
      if (data != null) {
        location = Location(lat: data.lat!, long: data.lon!);
      }
      // location = Location(lat: 25.204849, long: 55.270782);
    }
    if (location != null) {
      Get.to(AddressFormScreen(
        isEdit: false,
        location: location,
      ));
    } else {
      print("Location is null");
    }
  }

  /////////////////////// ADD ADDRESS //////////////////////////////
  Future<void> setAndUpdateAddress(SavedAddressesModel address) async {
    if (kDebugMode) {
      print("booking is ${address.toJson()}");
    }
    startLoader();
    try {
      await AppServices.setUserAddress(address);
      await updatesUserAddress(address);
    } on Exception catch (e) {
      stopLoader();
      if (kDebugMode) {
        print("addAddress error $e");
      }
    }
    notifyListeners();
  }

  /////////////////////// DELETE ADDRESS //////////////////////////////
  Future<void> deleteSavedAddress(SavedAddressesModel address, index) async {
    print(
        "Deleted ID${address.addressID}== Selected ID${selectedAddress?.addressID}");
    if (kDebugMode) {
      print("address deleted");
    }
    startLoader();
    try {
      /* when delete any address if its selected by user then change selectedAddressID in User doc */
      /*to first saved address in Addresses list userSavedAddress[0] if List is not empty */
      /* IF list is empty after deletion of address then savedAddressID will be null in USer Doc*/

      await AppServices.deleteUserAddress(address);
      if (userSavedAddress.isNotEmpty &&
          address.addressID == selectedAddress?.addressID) {
        await updatesUserAddress(userSavedAddress[0]);
      } else if (userSavedAddress.isEmpty) {
        await updatesUserAddress(null);
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("deleteSavedAddress error $e");
      }
    }
    stopLoader();
    notifyListeners();
  }

  /* Check and Flow Function For Address*/

  addressFormScreenInitEdit(
      SavedAddressesModel addressesModel, Location location) async {
    addressNameCont.text = addressesModel.addressName;
    buildingNameCont.text = addressesModel.buildingName;
    apartmentNumCont.text = addressesModel.apartmentNum;
    floorNumCont.text = addressesModel.floorNum.toString();
    additionalDirectionCont.text = addressesModel.additionalDirection;
    await setLocationForAddress(location);
    notifyListeners();
  }

  addressFormScreenInit(Location location) async {
    addressNameCont.clear();
    buildingNameCont.clear();
    apartmentNumCont.clear();
    floorNumCont.clear();
    additionalDirectionCont.clear();
    await setLocationForAddress(location);
    notifyListeners();
  }

  Future<void> setLocationForAddress(Location location) async {
    LocationServicesOfApp locationServices = LocationServicesOfApp();
    selectedAddressLocation = location;
    selectedAddressLocationAddress =
        await locationServices.getAddressFromLatLong(selectedAddressLocation);

    print("Location in Address Form screen");

    print(selectedAddressLocation?.toJson());
    print(selectedAddressLocationAddress);

    notifyListeners();
  }

  Future<void> saveAddress(
      bool isEdit, SavedAddressesModel? savedAddressLocation) async {
    String id = isEdit
        ? savedAddressLocation?.addressID ?? ""
        : DateTime.now().millisecondsSinceEpoch.toString();

    SavedAddressesModel savedAddresses = SavedAddressesModel(
      additionalDirection: additionalDirectionCont.text,
      userID: AppUser.user.email,
      floorNum: int.parse(floorNumCont.text),
      buildingName: buildingNameCont.text,
      addressID: id,
      apartmentNum: apartmentNumCont.text,
      address: selectedAddressLocationAddress!,
      location: selectedAddressLocation!,
      addressName: addressNameCont.text,
    );

    print(savedAddresses.toJson());
    await setAndUpdateAddress(savedAddresses);
    Get.back();
    addressNameCont.clear();
    buildingNameCont.clear();
    apartmentNumCont.clear();
    floorNumCont.clear();
    additionalDirectionCont.clear();
    selectedAddressLocation = null;
    selectedAddressLocationAddress = null;
    notifyListeners();
  }

  Future<void> updatesUserAddress(SavedAddressesModel? address) async {
    print("update user address ${address?.toJson()}");
    stopLoader();
    await AppServices.updateUserAddressID(address?.addressID);
    AppUser.user.selectedAddressID = address?.addressID;
    selectAddress();
    stopLoader();
    notifyListeners();
  }

  void selectAddress() {
    print("here");
    print(userSavedAddress.length);
    if (userSavedAddress.isNotEmpty && AppUser.user.selectedAddressID != null) {
      /* If saved Address List is not empty and one of them is selected by user */
      /* Selected by user means that address id is saved in USer Document then fetch it*/
      SavedAddressesModel address = userSavedAddress
          .where(
              (element) => element.addressID == AppUser.user.selectedAddressID)
          .first;
      selectedAddress = address;
      print("selected address for user is 1 ${selectedAddress?.toJson()}");
      setLocationForAddress(selectedAddress!.location);
    } else {
      selectedAddress = null;
      selectedAddressLocation = null;
      selectedAddressLocationAddress = null;
    }
    notifyListeners();
  }



  /* Disable and Enable Dates Function*/







  /*     API Call For Location */

  Future<LocationApiFromIPA?> getLocFromIpaAddress() async {
    startLoader();
    ApiRequests api = ApiRequests();
    String url = "http://ip-api.com/json";

    dynamic res = await api.getApi(url: url);
    stopLoader();
    notifyListeners();
    if (res is ErrorResponse) {
      print('Error from Api is ${res.errorDescription}');
      return null;
    } else {
      print("-------- hereeee");
      LocationApiFromIPA data = LocationApiFromIPA.fromJson(res);
      print("data is ${data.toJson()}");
      return data;
    }
  }
}
