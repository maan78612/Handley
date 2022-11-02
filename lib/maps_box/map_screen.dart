import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/maps_box/widgets/add_marker.dart';
import 'package:social_pro/maps_box/widgets/search_bar_map.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/provider/map_provider.dart';


class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> mapController = Completer();

  static final CameraPosition initialCameraPosition = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(AppUser.user.location!.lat, AppUser.user.location!.long),
      tilt: 59.440717697143555,
      zoom: 10);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MapProvider>(context, listen: false).clearOnMap();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, auth, _) {
      return Scaffold(
        body: Container(
            color: AppConfig.colors.whiteColor,
            child: Stack(
              children: [
                GoogleMap(
                  padding: EdgeInsets.zero,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  zoomGesturesEnabled: true,
                  tiltGesturesEnabled: false,
                  initialCameraPosition: initialCameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    mapController.complete(controller);
                  },
                  markers: Markers.markers,
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.sp),
                  decoration: BoxDecoration(
                    color: AppConfig.colors.whiteColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.sp),
                        bottomRight: Radius.circular(10.sp)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                await auth.fetchAllNearByUsers(auth.currentLocation);
                                MapsSearchBar.animateToNewLatLong(
                                    LatLng(auth.currentLocation!.lat, auth.currentLocation!.long),
                                    mapController);
                                Get.back();
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: AppConfig.colors.secondaryThemeColor,
                              )),
                          Spacer(),
                          Text(
                            "Nearby Professionals",
                            style: latoBlack.copyWith(
                                fontSize: 16.sp,
                                color: AppConfig.colors.secondaryThemeColor),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(right: 10.sp),
                            child: Image.asset(
                              AppConfig.images.logoShort,
                              height: 64.h,
                            ),
                          )
                        ],
                      ),
                      AutoComplete(mapController, false),
                    ],
                  ),
                ),
              ],
            )),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await auth.fetchAllNearByUsers(auth.currentLocation);
            MapsSearchBar.animateToNewLatLong(
                LatLng(auth.currentLocation!.lat, auth.currentLocation!.long),
                mapController);
            Provider.of<MapProvider>(context, listen: false).clearOnMap();
          },
          label: Text('My Location'),
          icon: Icon(Icons.location_on),
          backgroundColor: AppConfig.colors.themeColor,
        ),
      );
    });
  }
}
