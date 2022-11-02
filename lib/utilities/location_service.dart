import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:social_pro/model_classes/location_model.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';



class LocationServicesOfApp {
  Future<String> getAddressFromLatLong(loc.Location? loc) async {
    if (kIsWeb) {
      return "";
    } else {
      String address = "";
      if (loc != null) {
        List<Placemark>? placemarks =
            await placemarkFromCoordinates(loc.lat, loc.long);

        Placemark place = placemarks[0];
        String? name = place.name;
        String? subLocality = place.subLocality;
        String? locality = place.locality;
        String? administrativeArea = place.administrativeArea;
        String? postalCode = place.postalCode;
        String? country = place.country;
         address = "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";

      }

      print("user address is $address");
      return address;
    }
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.value(null);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return Future.value(null);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.value(null);
    }
    return await Geolocator.getCurrentPosition();
  }

  double findDistance(loc.Location myLocation, loc.Location bookLocation) {
    double distance = Geolocator.distanceBetween(
        myLocation.lat, myLocation.long, bookLocation.lat, bookLocation.long);
    distance = distance / 1609;
    if (kDebugMode) {
      print("Distance is = $distance");
    }
    return distance;
  }
}
