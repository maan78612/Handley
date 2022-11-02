import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/maps_box/widgets/search_bar_map.dart';
import 'package:social_pro/model_classes/location_model.dart';
import 'package:social_pro/model_classes/saved_addresses.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/provider/map_provider.dart';
import 'package:social_pro/ui/more/saved_addresses/address_form_screen.dart';
import 'package:social_pro/ui/shared/custom_loader.dart';


class MapScreenToSelectLocationWithClick extends StatefulWidget {
  bool isEdit;
  SavedAddressesModel? selectedAddress;

  /* for both Edit address (sends selectedAddress location) and add address(sends current location if enable otherwise location from IP address)*/
  Location location;

  MapScreenToSelectLocationWithClick(
      {Key? key,
      required this.isEdit,
      this.selectedAddress,
      required this.location})
      : super(key: key);

  @override
  State<MapScreenToSelectLocationWithClick> createState() =>
      _MapScreenToSelectLocationWithClickState();
}

class _MapScreenToSelectLocationWithClickState
    extends State<MapScreenToSelectLocationWithClick> {
  final Completer<GoogleMapController> mapController = Completer();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowAddressAndMarker();
    });

    super.initState();
  }

  Future<void> ShowAddressAndMarker() async {
    MapProvider mapProvider = Provider.of<MapProvider>(context, listen: false);
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    await mapProvider.initMarker(appProvider, false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, MapProvider>(
        builder: (context, appProvider, mapProvider, _) {
      return ModalProgressHUD(
        inAsyncCall: mapProvider.isLoading,
        progressIndicator: customLoader(),
        child: Scaffold(
          body: Container(
              color: AppConfig.colors.whiteColor,
              child: Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: CameraPosition(
                        bearing: 192.8334901395799,
                        target: LatLng(appProvider.selectedAddressLocation!.lat,
                            appProvider.selectedAddressLocation!.long),
                        tilt: 59.440717697143555,
                        zoom: 10),
                    markers: Set<Marker>.of(mapProvider.selectionMarker.values),
                    myLocationEnabled: true,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: true,
                    onTap: (LatLng location) async {
                      await appProvider.setLocationForAddress(Location(
                          lat: location.latitude, long: location.longitude));
                      await mapProvider.initMarker(appProvider, false);
                    },
                    onMapCreated: (GoogleMapController controller) {
                      mapController.complete(controller);
                      setState(() {});
                    },
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
                                  Get.off(AddressFormScreen(
                                    isEdit: widget.isEdit,
                                    location: appProvider.selectedAddressLocation!,
                                    selectedAddress: widget.selectedAddress,
                                  ));
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: AppConfig.colors.secondaryThemeColor,
                                )),
                            Spacer(),
                            Text(
                              "Select Location for Address",
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
                        AutoComplete(mapController, true),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      );
    });
  }
}
