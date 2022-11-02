import 'dart:async';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/app_keys.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/model_classes/location_model.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/provider/map_provider.dart';
import 'package:social_pro/utilities/dimension.dart';


class MapsSearchBar {
  static searchBar(Completer<GoogleMapController> mapController) {
    return Container(
      color: AppConfig.colors.whiteColor,
      padding: const EdgeInsets.all(8.0),
      child: SearchMapPlaceWidget(
        bgColor: AppConfig.colors.whiteColor,
        textColor: AppConfig.colors.secondaryThemeColor,
        iconColor: AppConfig.colors.themeColor,
        apiKey: AppKeys.googleMapKey,
        hasClearButton: true,
        placeType: PlaceType.address,
        placeholder: "Enter the location",
        onSelected: (Place place) async {
          Geolocation? geolocation = await place.geolocation;
          await animateToNewLatLong(geolocation!.coordinates!, mapController);
          await animateToNewLatLngBounds(geolocation, mapController);
        },
      ),
    );
  }

  static Future<void> animateToNewLatLong(
      LatLng latLng, Completer<GoogleMapController> mapController) async {
    final c = await mapController.future;
    c.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  static Future<void> animateToNewLatLngBounds(Geolocation geolocation,
      Completer<GoogleMapController> mapController) async {
    final c = await mapController.future;
    c.animateCamera(CameraUpdate.newLatLngBounds(
      geolocation.bounds,
      0,
    ));
  }
}

/* Temporary for showing search on Google map*/

class AutoComplete extends StatefulWidget {
  Completer<GoogleMapController> mapController;
  bool isAddress;

  AutoComplete(this.mapController, this.isAddress);

  @override
  _AutoCompleteState createState() => new _AutoCompleteState();
}

class _AutoCompleteState extends State<AutoComplete> {
  GlobalKey<AutoCompleteTextFieldState<LocationStatic>> key = new GlobalKey();
  List<LocationStatic> locationStatic = [
    LocationStatic(
        long: 55.31231841932568, lat: 25.18925240976697, address: "Dubai"),
    LocationStatic(
        long: 55.479177482703925,
        lat: 25.399757302613395,
        address: "Ajman City Centre - Al Ittihad Street - Ajman"),
    LocationStatic(
        long: 55.51224696920948,
        lat: 25.32865822559098,
        address: "Sharjah International Airport - Sharjah"),
    LocationStatic(
        long: 55.327733771874584,
        lat: 25.283991474472536,
        address: "Abu Hail - Dubai"),
    LocationStatic(
        long: 58.16731205597647, lat: 23.378202923738368, address: "Muscat"),
    LocationStatic(
        long: 6.1198105986631735,
        lat: 45.9010702990414,
        address: "Annecy, France"),
  ];

  @override
  void initState() {
    super.initState();
  }

  bool fillColor = false;

  @override
  Widget build(BuildContext context) {
    return Consumer2<MapProvider, AppProvider>(
        builder: (context, mapProvider, appProvider, _) {
      return Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: AutoCompleteTextField<LocationStatic>(
            key: key,
            controller: mapProvider.mapSearchBar,
            focusNode: mapProvider.mapFocusNode,
            suggestions: locationStatic,
            style: latoRegular.copyWith(fontSize: 16.sp),
            clearOnSubmit: false,
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Search for a location…',
              hintStyle: latoBold.copyWith(
                  fontSize: 16.sp, color: const Color(0xffD9D4D5)),
              filled: true,
              prefixIcon: Image.asset(
                AppConfig.images.search,
                scale: 3.sp,
                fit: BoxFit.scaleDown,
                color: AppConfig.colors.secondaryThemeColor,
              ),
              fillColor: fillColor
                  ? AppConfig.colors.whiteColor
                  : AppConfig.colors.fillColor,
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                borderSide:
                    BorderSide(color: AppConfig.colors.fieldBorderColor),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                borderSide:
                    BorderSide(color: AppConfig.colors.fieldBorderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                borderSide:
                    BorderSide(color: AppConfig.colors.enableBorderColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                borderSide:
                    BorderSide(color: AppConfig.colors.fieldBorderColor),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide:
                    BorderSide(color: AppConfig.colors.fieldBorderColor),
              ),
            ),
            itemBuilder: (context, item) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  item.address,
                  style: latoRegular.copyWith(
                      fontSize: 14.sp,
                      color: AppConfig.colors.secondaryThemeColor),
                ),
              );
            },
            itemFilter: (item, query) {
              return item.address.toLowerCase().startsWith(query.toLowerCase());
            },
            itemSorter: (a, b) {
              return a.address.compareTo(b.address);
            },
            itemSubmitted: (item) async {
              if (widget.isAddress) {
                mapProvider.mapSearchBar.text = item.address;
                await appProvider.setLocationForAddress(
                    Location(lat: item.lat, long: item.long));

                await mapProvider.initMarker(appProvider,false);
              } else {
                await Provider.of<AuthProvider>(context, listen: false)
                    .fetchAllNearByUsers(
                        Location(lat: item.lat, long: item.long));
                mapProvider.mapSearchBar.text = item.address;
              }

              MapsSearchBar.animateToNewLatLong(
                  LatLng(item.lat, item.long), widget.mapController);

              print(mapProvider.mapSearchBar.text);

              setState(() {});
            },
          ));
    });
  }
}

class LocationStatic {
  late double lat;
  late double long;
  late String address;

  LocationStatic(
      {required this.lat, required this.long, required this.address});
}
