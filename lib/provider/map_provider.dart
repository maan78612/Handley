import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/provider/chat_provider.dart';
import 'package:social_pro/chat_box/services/chat_services.dart';
import 'package:social_pro/constants/app_constants.dart';


class MapProvider with ChangeNotifier {
  bool isLoading = false;

  void startLoader() {
    isLoading = true;
    if (kDebugMode) {
      print(isLoading);
    }
    notifyListeners();
  }

  void stopLoader() {
    isLoading = false;
    if (kDebugMode) {
      print(isLoading);
    }
    notifyListeners();
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

  /* temporary search field*/

  TextEditingController mapSearchBar = TextEditingController(text: "");
  FocusNode mapFocusNode = FocusNode();

  void clearOnMap() {
    print("on map clear");
    mapSearchBar.clear();
    mapSearchBar.text = "";
    notifyListeners();
  }

  /* For click to add marker Map Screen*/

  Map<MarkerId, Marker> selectionMarker = {};
  Map<MarkerId, Marker> staticMarker = {};

  late BitmapDescriptor selectLocationMapMarker;
  late BitmapDescriptor staticLocationMarker;

  Future<void> initMarker(AppProvider appProvider, bool isStatic) async {
    print("isStatic => $isStatic");
    mapSearchBar.text = appProvider.selectedAddressLocationAddress??"";
    print("search bar data ${mapSearchBar.text}");
    MarkerId markerId =
        isStatic ? MarkerId("staticMarkerID") : MarkerId("selectionMarkerID");
    Marker marker = Marker(
        markerId: markerId,
        position: LatLng(appProvider.selectedAddressLocation!.lat,
            appProvider.selectedAddressLocation!.long),
        icon: isStatic ? staticLocationMarker : selectLocationMapMarker);
    if (isStatic) {
      staticMarker[markerId] = marker;
      print(markerId);
      print(staticMarker.length);
    } else {
      selectionMarker[markerId] = marker;
      print(markerId);
      print(selectionMarker.length);
    }

    print(mapSearchBar.text);

    notifyListeners();
  }

  Future<void> customStaticMarker() async {
    Uint8List? markerImageBytes;
    /* make icon fromm assets*/
    ByteData data =
        await rootBundle.load(AppConfig.images.staticLocationMarker);
    markerImageBytes = data.buffer.asUint8List();

    Codec codec =
        await instantiateImageCodec(markerImageBytes, targetWidth: 80);
    FrameInfo fi = await codec.getNextFrame();

    final Uint8List? markerImage =
        (await fi.image.toByteData(format: ImageByteFormat.png))
            ?.buffer
            .asUint8List();

    staticLocationMarker = BitmapDescriptor.fromBytes(markerImage!);
    print("here staticLocationMarker ========> ${staticLocationMarker}");
    notifyListeners();
  }

  Future<void> customSelectionMarker() async {
    Uint8List? markerImageBytes;
    /* make icon fromm assets*/
    ByteData data =
        await rootBundle.load(AppConfig.images.selectLocationMapMarker);
    markerImageBytes = data.buffer.asUint8List();

    Codec codec =
        await instantiateImageCodec(markerImageBytes, targetWidth: 80);
    FrameInfo fi = await codec.getNextFrame();

    final Uint8List? markerImage =
        (await fi.image.toByteData(format: ImageByteFormat.png))
            ?.buffer
            .asUint8List();
    selectLocationMapMarker = BitmapDescriptor.fromBytes(markerImage!);
    print("here selectLocationMapMarker ========> ${selectLocationMapMarker}");
    notifyListeners();
  }
}
