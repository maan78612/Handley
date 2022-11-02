import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/ui/home/widgets/professional_dialog_card.dart';

class Markers {
  static Set<Marker> markers = {};
  static String iconUrl = "";
  static BitmapDescriptor? myMarker;
  static Uint8List? markerImageBytes;

  static Future<void> customMarker(UserData markerUser) async {
    iconUrl = markerUser.profession?.mapIcons ?? "";
    if (kDebugMode) {
      print("user image is $iconUrl");
    }

    if (iconUrl == "") {
      /* make icon fromm assets*/
      ByteData data = await rootBundle.load(AppConfig.images.logoShort);
      markerImageBytes = data.buffer.asUint8List();
    } else {
      /* make icon fromm network image*/
      final File markerImageFile =
          await DefaultCacheManager().getSingleFile(iconUrl);
      markerImageBytes = await markerImageFile.readAsBytes();
    }
    Codec codec = await instantiateImageCodec(markerImageBytes!,
        targetWidth: iconUrl == "" ? 120 : 80);
    FrameInfo fi = await codec.getNextFrame();

    final Uint8List? markerImage =
        (await fi.image.toByteData(format: ImageByteFormat.png))
            ?.buffer
            .asUint8List();

    myMarker = BitmapDescriptor.fromBytes(markerImage!);
    addMarker(markerUser, myMarker!);
  }

  static addMarker(UserData markerUser, BitmapDescriptor myMarker) {
    if (kDebugMode) {
      print("marker added for ${markerUser.firstName} ");
    }
    markers.add(Marker(
      draggable: false,
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(markerUser.location!.lat.toString()),
      position: LatLng(markerUser.location!.lat, markerUser.location!.long),
      infoWindow: InfoWindow(
          title: "${markerUser.profession!.title} \n ${markerUser.firstName} ",
          snippet: 'Click here to know more',
          onTap: () {
            Get.dialog(ProfessionalDialogCard(professionalUser: markerUser));
          }),
      icon: myMarker,
    ));
  }





}
