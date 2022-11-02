import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/UI/Shared/image_media.dart';
import 'package:social_pro/maps_box/widgets/add_marker.dart';
import 'package:social_pro/model_classes/disableDates.dart';
import 'package:social_pro/model_classes/location_model.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/provider/biometric_provider.dart';
import 'package:social_pro/provider/chat_provider.dart';
import 'package:social_pro/model_classes/professions.dart';
import 'package:social_pro/provider/map_provider.dart';
import 'package:social_pro/services/auth_services.dart';
import 'package:social_pro/ui/auth/sign_in_view.dart';
import 'package:social_pro/ui/auth/widget/sucessfully_sign_up_btm_sheet.dart';
import 'package:social_pro/ui/dashoard/dashboard.dart';
import 'package:social_pro/utilities/firestorage_service.dart';
import 'package:social_pro/utilities/enums.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/firebase_collections.dart';
import 'package:social_pro/utilities/app_utility.dart';
import 'package:social_pro/utilities/location_service.dart';
import 'package:social_pro/utilities/show_message.dart';
import 'package:social_pro/utilities/validator.dart';

class AuthProvider extends ChangeNotifier {
  FStorageServices fStorage = FStorageServices();
  UserData? appUserData;

  //////////////////////Login Sign Up/////////////////////////

  ///////////loading////////////
  bool isLoading = false;

  String app = "From app";

  ///////////login variables////////////
  bool passVisible = false;

  ///////////signUp variables////////////
  var isAcceptedConfirmPWDProvider = -1;
  var isAcceptedPWDProvider = -1;
  var isAcceptedEmail = -1;

  bool passVisibleSignUp = false;
  bool passVisibleSignUp2 = false;
  bool selectTerms = false;
  File? userImage;
  File? doc1;
  File? doc2;

  ///////////login Controllers////////////
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPassController = TextEditingController();

  ///////////SignUp Controllers////////////
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lasttNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController experienceController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  ///////////login focus node////////////
  FocusNode loginPassFocusNode = FocusNode();
  FocusNode loginEmailFocusNode = FocusNode();

  ///////////SignUp focus node////////////
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode experienceFocusNode = FocusNode();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  FocusNode dropDownFocusNode = FocusNode();

  String imageUrlToSet = '';
  UserGender? gender;

  Timestamp? birthDateUser;
  String doc1Url = '';
  String doc2Url = '';

  void startLoader() {
    print("==========Start loader============");
    isLoading = true;
    notifyListeners();
  }

  void stopLoader() {
    print("==========Stop loader============");
    isLoading = false;
    notifyListeners();
  }

  Future<void> matchPassProvider(String value) async {
    if (FieldValidator.validateConfirmPassword(value) ==
        "Confirm Password is Required") {
      isAcceptedConfirmPWDProvider = -1;
    } else if (passwordController.value.text.toString() ==
        confirmPasswordController.value.text.toString()) {
      isAcceptedConfirmPWDProvider = 1;
    } else {
      isAcceptedConfirmPWDProvider = 0;
    }

    notifyListeners();
  }

  saveProfile(GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      updateUser(userImage);
      notifyListeners();
    }
  }

  clearSignInData() {
    loginEmailController.clear();
    loginPassController.clear();
    isAcceptedConfirmPWDProvider = -1;
    isAcceptedPWDProvider = -1;
    isAcceptedEmail = -1;
    notifyListeners();
  }

  clearSignUpData() {
    firstNameController.clear();
    lasttNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    experienceController.clear();
    descriptionController.clear();
    selectedProfession = null;
    imageUrlToSet = '';
    doc1Url = '';
    doc1 = null;
    doc2Url = '';
    doc2 = null;
    isAcceptedPWDProvider = -1;
    isAcceptedConfirmPWDProvider = -1;
    isAcceptedEmail = -1;
    userImage = null;
    selectTerms = false;
    isProfessional = false;
    gender = null;
    birthDateUser = null;
    notifyListeners();
  }

  selectTermToggle() {
    selectTerms = !selectTerms;
    notifyListeners();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////BACKEND/////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  /////////////////////////SIGN UP///////////////////////////

  ChatProvider p = Provider.of<ChatProvider>(Get.context!, listen: false);

  Future getUserImageFunc() async {
    File? pickedFile = await Get.bottomSheet(UserImageOptionSheet());
    if (pickedFile != null) {
      userImage = File(pickedFile.path);
    } else {
      if (kDebugMode) {
        print("not added");
      }
    }

    notifyListeners();
  }

  Future getDocumentFile(int index) async {
    File? pickedFile = await Get.bottomSheet(DocumentFileOptionSheet());
    if (pickedFile != null) {
      print("insert at $index");
      if (index == 0) {
        doc1 = File(pickedFile.path);
      } else if (index == 1) {
        doc2 = File(pickedFile.path);
      }
    } else {
      if (kDebugMode) {
        print("not added");
      }
    }
    if (kDebugMode) {
      print("doc 1 ${doc1?.path ?? "null"}");
      print("doc 2 ${doc2?.path ?? "null"}");
    }

    notifyListeners();
  }

  void deleteDocument(int index) {
    if (index == 0) {
      doc1 = null;
    } else {
      doc2 = null;
    }
    notifyListeners();
  }

  Future<void> matchEmail(String value) async {
    if (FieldValidator.validateEmail(value) ==
        "Please enter a valid Email Address") {
      isAcceptedEmail = 0;
    } else if (FieldValidator.validateEmail(value) == "Email is Required") {
      isAcceptedEmail = -1;
    } else {
      isAcceptedEmail = 1;
    }

    print("here $isAcceptedEmail");

    notifyListeners();
  }

  Future<void> registerUser(UserType userType) async {
    FocusScope.of(Get.context!).requestFocus(FocusNode()); // close keyboard
    startLoader();
    await fetchCurrentLatLng();
    DocumentSnapshot userDocument =
        await FBCollections.users.doc(emailController.text.trim()).get();

    if (userDocument.exists) {
      if (kDebugMode) {
        print("user exist");
      }
      ShowMessage.snackBar("Oops!", "User already exists", false);
    } else {
      if (kDebugMode) {
        print("user not exist");
      }
      AuthServices.createUserWithEmailPassword(
              emailController.text.trim(), passwordController.text.trim())
          .then((value) async {
        if (kDebugMode) {
          print(value);
        }
        createUserInDB(userImage, emailController.text.trim(), userType);
      });
    }
  }

  void createUserInDB(File? imageFile, String email, UserType userType) async {
    if (kDebugMode) {
      print("image file is $imageFile");
    }
    imageUrlToSet = "";
    doc1Url = "";
    doc2Url = "";

    /* if there is Image then upload it*/
    if (imageFile != null) {
      imageUrlToSet = await fStorage.uploadSingleFile(
          bucketName: "Profile Images", file: imageFile, userEmail: email);
    }
    /* if professional attached document files then upload it*/
    if (userType == UserType.professional) {
      if (doc1 != null) {
        doc1Url = await fStorage.uploadSingleFile(
            bucketName: "User Additional Documents",
            file: doc1!,
            userEmail: email);
      }
      if (doc2 != null) {
        doc2Url = await fStorage.uploadSingleFile(
            bucketName: "User Additional Documents",
            file: doc2!,
            userEmail: email);
      }
    }

    String address = await _loc.getAddressFromLatLong(currentLocation);
    int? exp = isProfessional ? int.parse(experienceController.text) : null;

    await FBCollections.users
        .doc(emailController.text)
        .set(UserData(
          createdAt: Timestamp.now(),
          firstName: firstNameController.text,
          lastName: lasttNameController.text,
          professionID: selectedProfession?.id ?? "",
          email: emailController.text,
          imageUrl: imageUrlToSet,
          location: currentLocation,
          distanceToFindUser: 50,
          fcm: '',
          address: address,
          role: userType.index,
          userType: userType,
          rating: 0,
          experience: exp,
          description: descriptionController.text,
          satisfactionPercentage: 100,
          numberOfJobs: 0,
          ratingCount: 0,
          doc2Url: doc2Url,
          doc1Url: doc1Url,
          disableDates: [],
        ).toJson())
        .then((value) async {
      appUserData = await getUserFromDB(emailController.text);
      if (appUserData != null) {
        AppUser.user = appUserData!;
      }

      await fetchInitialData();

      stopLoader();

      Get.bottomSheet(SuccessfullySignUpBottom(),
          isDismissible: false, enableDrag: false);
    });
  }

  Future<void> fetchInitialData() async {
    if (currentLocation != null) {
      await fetchAllNearByUsers(currentLocation);
    }

    await fetchAllUsers();
    await p.fetchMyChatRooms();
    await Provider.of<AppProvider>(Get.context!, listen: false)
        .fetchUserBookings();
    await Provider.of<AppProvider>(Get.context!, listen: false)
        .fetchUserNotifications();
    await Provider.of<AppProvider>(Get.context!, listen: false)
        .fetchUserSavedAddress();
    /* Create custom marker for map [static marker black]*/
    await Provider.of<MapProvider>(Get.context!, listen: false)
        .customStaticMarker();
    /* Create custom marker for map [selection marker red]*/
    await Provider.of<MapProvider>(Get.context!, listen: false)
        .customSelectionMarker();
    notifyListeners();
  }

  void updateUser(File? imageFile) async {
    imageUrlToSet = "";
    startLoader();
    /* checking profile image is updated or not then upload in database*/
    if (imageFile != null) {
      imageUrlToSet = await fStorage.uploadSingleFile(
          bucketName: "Profile Images",
          file: imageFile,
          userEmail: appUserData!.email);
    } else {
      imageUrlToSet = appUserData!.imageUrl;
    }

    /* Updated Data option on profile page*/
    AppUser.user.firstName = firstNameController.text;
    AppUser.user.lastName = lasttNameController.text;
    AppUser.user.imageUrl = imageUrlToSet;
    AppUser.user.gender = gender?.index;
    AppUser.user.dob = birthDateUser;
    if (AppUser.user.userType == UserType.professional) {
      AppUser.user.description = descriptionController.text;
      AppUser.user.experience = int.parse(experienceController.text);
    }

    await FBCollections.users
        .doc(AppUser.user.email)
        .update(AppUser.user.toJson())
        .then((value) async {
      appUserData = await getUserFromDB(appUserData!.email);
      if (appUserData != null) {
        AppUser.user = appUserData!;
      }
      stopLoader();
      clearSignUpData();
      Get.back();
    });
  }

  Future<void> updateFCM(String fcm, String email) async {
    await FBCollections.users.doc(email).update({"fcm": fcm});
  }

  Future<UserData?> getUserFromDB(String email) async {
    DocumentSnapshot? doc;
    if (kDebugMode) {
      print("email $email");
    }
    try {
      await getFcmToken();
      print("AppUtility.freshFCM ${AppUtility.freshFCM}");
      await updateFCM(AppUtility.freshFCM, email);
      doc = await FBCollections.users.doc(email).get();
    } on Exception catch (e) {
      stopLoader();
    }

    if (doc != null) {
      if (!doc.exists) {
        stopLoader();
        return null;
      }

      UserData user = UserData.fromJson(doc.data());

      await getDisableDates(user);

      return user;
    }
    stopLoader();
    return null;
  }

  /////////////////////////Disable Dates///////////////////////////

  Future<void> getDisableDates(UserData user) async {
    if (user.userType == UserType.professional) {
      List<DisableDates> disableDates =
          await AuthServices.getDisableDatesService(user);
      user.disableDates = disableDates;
      notifyListeners();
    }
  }

  Future<DisableDates?> disableOrEnableLDate(DisableDates disableDate) async {
    if (kDebugMode) {
      print("disableOrEnableLDate");
    }
    startLoader();
    try {
      await AuthServices.updateDisableDatesForProfessional(disableDate);
      await getDisableDates(AppUser.user);
      DisableDates? checkDisableDate =
          checkDisableDates(disableDate.disableDate.toDate());
      stopLoader();
      return checkDisableDate;
    } on Exception catch (e) {
      stopLoader();
      if (kDebugMode) {
        print("post booking error $e");
      }
    }
    stopLoader();
    return null;
  }

  DisableDates? checkDisableDates(DateTime selectedDate) {
    DisableDates? checkDisableDate;
    for (DisableDates element in appUserData!.disableDates) {
      print(isSameDate(element.disableDate.toDate(), selectedDate));
      if (isSameDate(element.disableDate.toDate(), selectedDate)) {
        checkDisableDate = element;
        break;
      }
    }
    notifyListeners();
    return checkDisableDate;
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

/////////////////////////LOG IN///////////////////////////

  Future<void> autoLogin() async {
    startLoader();
    BiometricProvider biometricProvider =
        Provider.of(Get.context!, listen: false);

    User? user = await AuthServices.getCurrentUser();

    if (kDebugMode) {
      print("$user");
    }

    if (user != null) {
      if (kDebugMode) {
        print("starting biometric authentication");
      }
      await biometricProvider.onInIt().then((isAuthenticated) async {
        if (kDebugMode) {
          print("is authenticated in auto sign in function $isAuthenticated");
        }
        if (isAuthenticated) {
          if (kDebugMode) {
            print("not null");
            print("user login");
          }

          await handleSignIn(user.email!);
          print("login auto ${AppUser.user.toJson()} ");
          stopLoader();
        } else {
          stopLoader();
          Get.off(() => SignInView());
        }
      });
    } else {
      stopLoader();
      Get.off(() => SignInView());
    }

    notifyListeners();
  }

  Future<void> loginUser() async {
    if (kDebugMode) {
      print(loginEmailController.text);
      print(loginPassController.text);
    }

    AppUtility.hideKeyboard();

    startLoader();
    try {
      User? user = await AuthServices.signInWithEmailPassword(
          loginEmailController.text.trim(), loginPassController.text.trim());
      if (kDebugMode) {
        print("$user");
      }
      if (user != null) {
        if (kDebugMode) {
          print("not null");
          print("user login");
        }
        passwordController.clear();

        await handleSignIn(user.email!);
        stopLoader();
        print("login manually ${AppUser.user.toJson()} ");
      } else {
        stopLoader();
        ShowMessage.snackBar("Authentication Error",
            "please check your login credential", false);
      }
    } catch (er) {
      stopLoader();
      String error = er.toString();
      if (kDebugMode) {
        print("error = $error");
      }
      error.contains('WRONG_PASSWORD')
          ? Get.snackbar("Authentication Error", "Wrong password",
              colorText: Colors.white,
              borderRadius: 10,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              backgroundColor: Colors.red)
          : error.contains('USER_NOT_FOUND')
              ? Get.snackbar("Authentication Error", "user not found",
                  colorText: Colors.white,
                  borderRadius: 10,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  backgroundColor: Colors.red)
              : Get.snackbar(
                  "Authentication Error", "please check your login credential",
                  colorText: Colors.white,
                  borderRadius: 10,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  backgroundColor: Colors.red);
    }
  }

  getFcmToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      if (kDebugMode) {
        print("fcm =  $token");
      }
      AppUtility.freshFCM = token!;
    });
  }

  Future<void> handleSignIn(String email) async {
    if (kDebugMode) {
      print("email $email");
    }
    try {
      await fetchCurrentLatLng();

      appUserData = await getUserFromDB(email);
      if (appUserData != null) {
        AppUser.user = appUserData!;

        await updateLocation();
        if (kDebugMode) {
          print("=============${AppUser.user.toJson()}=============");
          print("user found = ${appUserData!.toJson()}");
        }
        await fetchInitialData().whenComplete(() {
          Get.offAll(DashBoard(index: 0));
        });
      } else {
        Get.offAll(SignInView());
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> updateFcm() async {
    await FBCollections.users
        .doc(emailController.text)
        .update({"fcm": AppUtility.myFcmToken});
  }

  Future<void> updateLocation() async {
    appUserData?.location = currentLocation;
    appUserData?.address =
        await _loc.getAddressFromLatLong(appUserData!.location);

    await FBCollections.users
        .doc(appUserData!.email)
        .update(appUserData!.toJson())
        .then((value) async {
      AppUser.user = appUserData!;
    });
  }

  //////////////////////////////////////FORGOT PASSWORD/////////////////////////////

  Future forgotPassword(String email) async {
    startLoader();
    AppUtility.hideKeyboard();
    await AuthServices.sendResetPassEmail(email.trim());
    stopLoader();
  }

  //////////////////////////////PROFILE//////////////////////////////////////
// To move slider on front end
  Future<void> setDistance(double value) async {
    appUserData!.distanceToFindUser = value;

    notifyListeners();
  }

  // To save data on Firebase
  Future<void> saveDistance(double value) async {
    await FBCollections.users
        .doc(appUserData!.email)
        .update({"distance_to_find_user": value});

    notifyListeners();
  }

  final LocationServicesOfApp _loc = LocationServicesOfApp();
  Location? currentLocation;

  Future<void> fetchCurrentLatLng() async {
    var internet = await check();
    if (internet) {
      Position? pos = await _loc.getCurrentLocation();
      if (pos != null) {
        currentLocation = Location(lat: pos.latitude, long: pos.longitude);
        if (kDebugMode) {
          print("current location is ${currentLocation!.toJson()}");
        }
      }
    } else {
      print(currentLocation);
      Provider.of<AuthProvider>(Get.context!, listen: false).stopLoader();
      Get.snackbar("No internet Connection", "Please connect internet",
          colorText: AppConfig.colors.whiteColor,
          backgroundColor: AppConfig.colors.secondaryThemeColor);
    }
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  StreamSubscription<List<UserData>>? allNearByUserStream;
  List<UserData> nearByUser = [];

  Future<void> fetchAllNearByUsers(Location? locationForNearBy) async {
    var value = await AuthServices.getAllUsers();
    nearByUser.clear();
    Markers.markers.clear();
    if (allNearByUserStream == null) {
      await value.listen((event) async {
        var temp = event
            .where((b) =>
                b.email != AppUser.user.email &&
                b.userType != AppUser.user.userType)
            .toList();

        nearByUser.clear();
        Markers.markers.clear();
        for (var b in temp) {
          if (b.location != null) {
            /* to check if any user contains null value in location*/
            double dist = LocationServicesOfApp()
                .findDistance(locationForNearBy!, b.location!);

            if (dist <= AppUser.user.distanceToFindUser) {
              nearByUser.add(b);

              if (AppUser.user.userType == UserType.customer)
                await Markers.customMarker(b);
            }
          }
        }
        filterNearByProfessionalListFunc();
        if (kDebugMode) {
          print("nearBy markers length${Markers.markers.length}");
          print("total nearBy users are  ${nearByUser.length}");
          print(
              "total nearBy Professionals are  ${professionalNearByUsers.length}");
        }
        notifyListeners();
      });
    }
  }

  List<UserData> professionalNearByUsers = [];
  String? selectedProfessionalID;

  void filterNearByProfessionalListFunc() {
    professionalNearByUsers = [];

    professionalNearByUsers.addAll(List.from(nearByUser
        .where((element) => element.userType == UserType.professional)));
    if (selectedProfessionalID == null) {
      professionalNearByUsers = professionalNearByUsers;
    } else {
      professionalNearByUsers.clear();
      professionalNearByUsers.addAll(List.from(nearByUser.where((element) {
        return element.profession?.id == selectedProfessionalID;
      }).toList()));
    }
    if (kDebugMode) {
      print(professionalNearByUsers.length);
      print(nearByUser.length);
      print("in filterProfessionalListFunc $selectedProfessionalID");
      print(professionalNearByUsers);
      if (professionalNearByUsers.isNotEmpty) {
        print(professionalNearByUsers.first.profession?.title);
      }
    }

    notifyListeners();
  }

  StreamSubscription<List<UserData>>? allUserStream;
  List<UserData> allUser = [];

  Future<void> fetchAllUsers() async {
    var value = AuthServices.getAllUsers();
    if (allUserStream == null) {
      value.listen((event) async {
        allUser.clear();

        var temp = event
            .where((b) =>
                b.email != AppUser.user.email &&
                b.userType != AppUser.user.userType)
            .toList();
        for (UserData b in temp) {
          allUser.add(b);
          /* If we are Customers then we are getting Professionals So We have to get their disable dates as well*/
          if (AppUser.user.userType == UserType.customer) {
            await getDisableDates(b);
          }
        }
        if (kDebugMode) {
          print("total  users count  ${allUser.length}");
        }
      });
      notifyListeners();
    }
  }

  bool isProfessional = false;

  void continueAsProfessional() {
    isProfessional = true;
    if (kDebugMode) {
      print("is professional is $isProfessional");
    }
    notifyListeners();
  }

  List<Professions> professionList = [];
  var professionMap;
  Professions? selectedProfession;

  Future<void> fetchAllProfessions() async {
    professionList = await AuthServices.getAllProfessions();
/*    professionList.insert(
        0,
        Professions(
          createdAt: Timestamp.now(),
          id: '123',
          image:
              "https://thumbs.dreamstime.com/z/fire-driver-logo-vector-design-template-fire-driver-logo-vector-design-template-car-steering-wheel-burning-fire-logo-icon-vector-209533383.jpg",
          title: 'Checking 123 123 132',
        ));
    professionList.add(Professions(
      createdAt: Timestamp.now(),
      id: '111',
      image:
          "https://images-platform.99static.com//5MW0UR8XoQTk1y2KBHiWuHxuBgQ=/420x3172:1005x3757/fit-in/590x590/99designs-contests-attachments/90/90380/attachment_90380033",
      title: 'Checking 122222',
    ));*/

    if (kDebugMode) {
      print("length of all professions are ${professionList.length}");
    }
    populateDropDow();
  }

  void selectProfession(newVal) {
    selectedProfession = newVal!;
    notifyListeners();
  }

  /*======================= Filter Functions For Customer Side====================================*/

  List<Professions> selectedFiltersList = [];
  List<UserData> filterProfessionals = [];
  DateTime selectedDateToFilterProfessionals = DateTime.now();

  void applyFilterInitially() {
    filterProfessionals = [];
    selectedFiltersList = [];
    filterProfessionals.addAll(allUser);
    applyDateFilter();
    notifyListeners();
  }

  void applyFilter(List<Professions> professions) {
    filterProfessionals = [];
    selectedFiltersList = [];
    if (professions.isEmpty) {
      applyFilterInitially();
    } else {
      applyServiceFilter(professions);
    }

    applyDateFilter();
    notifyListeners();
  }

  void applyServiceFilter(List<Professions> professions) {
    selectedFiltersList.clear();
    filterProfessionals.clear();
    selectedFiltersList.addAll(professions);
    selectedFiltersList.forEach((filter) {
      allUser.forEach((user) {
        if (user.professionID == filter.id) {
          print(user.professionID);
          filterProfessionals.add(user);
        }
      });
    });
    print(" filter length ${selectedFiltersList.length}");
    print(" filtered professional length ${filterProfessionals.length}");

    notifyListeners();
  }

  void removeServiceFilter(Professions professions) {
    selectedFiltersList.remove(professions);

    allUser.forEach((user) {
      if (user.professionID == professions.id) {
        filterProfessionals.remove(user);
      }
    });
    if (selectedFiltersList.isEmpty) {
      applyFilterInitially();
    }
    print(selectedFiltersList.length);
    notifyListeners();
  }

  void selectDateForFilter(DateTime date) {
    selectedDateToFilterProfessionals = date;
    applyFilter(selectedFiltersList);

    notifyListeners();
  }

  void applyDateFilter() {
    List<UserData> tempProfessionals = [];
    tempProfessionals.addAll(filterProfessionals);
    print(
        " filtered TEMPORARY  professional with Date length ${tempProfessionals.length}");
    filterProfessionals.forEach((user) {
      user.disableDates.forEach((date) {
        if (isSameDate(
            date.disableDate.toDate(), selectedDateToFilterProfessionals)) {
          tempProfessionals
              .removeWhere((element) => element.email == user.email);
        }
      });
    });
    filterProfessionals = [];
    filterProfessionals.addAll(tempProfessionals);
    print(
        " filtered professional with Date length ${filterProfessionals.length}");

    notifyListeners();
  }

  void populateDropDow() {
    professionMap = professionList.map((item) {
      return DropdownMenuItem<Professions>(
        value: item,
        child: Text(item.title),
      );
    }).toList();
  }

  Future<void> enableLocationFunction() async {
    LocationPermission permission;
    Position? pos;
    print("enableLocationFunction");
    permission = await Geolocator.checkPermission();
    print(
        "============= Permissiion status is $permission ===================");
    if (permission != LocationPermission.denied ||
        permission != LocationPermission.deniedForever) {
      try {
        pos = await Geolocator.getCurrentPosition();
      } on Exception catch (e) {
        pos = null;
      }
    }

    print("=========pos is $pos ==============");
    if (pos != null) {
      currentLocation = Location(lat: pos.latitude, long: pos.longitude);
      if (appUserData != null) {
        startLoader();
        await updateLocation();
        await fetchAllNearByUsers(currentLocation);
        stopLoader();
      }
    } else {
      disableLocationFunction();
    }

    notifyListeners();
  }

  Future<void> disableLocationFunction() async {
    print(appUserData?.location);

    if (appUserData != null) {
      professionalNearByUsers = [];
      AppUser.user.location = null;
      currentLocation = null;
      appUserData?.location = null;
      await updateLocation();
    }

    notifyListeners();
  }

  void onDispose() {
    clearSignInData();
    clearSignUpData();
    allNearByUserStream?.cancel();
    allNearByUserStream = null;
    allUserStream?.cancel();
    allUserStream = null;
    notifyListeners();
  }
}
