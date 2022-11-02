import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/model_classes/location_model.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/provider/map_provider.dart';


class StaticMarkerMap extends StatefulWidget {
  Location location;

  StaticMarkerMap({Key? key, required this.location}) : super(key: key);

  @override
  State<StaticMarkerMap> createState() => _StaticMarkerMapState();
}

class _StaticMarkerMapState extends State<StaticMarkerMap> {
  Completer<GoogleMapController> mapController = Completer();

  Future<void> ShowAddressAndMarker() async {
    MapProvider mapProvider = Provider.of<MapProvider>(context, listen: false);
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    await mapProvider.initMarker(appProvider, true);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowAddressAndMarker();
    });
    super.initState();
  }

  @override
  void dispose() {
    mapController = Completer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, MapProvider>(
        builder: (context, appProvider, mapProvider, _) {
      return Container(
        height: 200.h,
        decoration: BoxDecoration(
            color: AppConfig.colors.red,
            borderRadius: BorderRadius.all(Radius.circular(10.sp))),
        child: GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: false,
          initialCameraPosition: CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(widget.location.lat, widget.location.long),
              tilt: 59.440717697143555,
              zoom: 10),
          markers: Set<Marker>.of(mapProvider.staticMarker.values),
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          onMapCreated: (GoogleMapController controller) async {
            mapController.complete(controller);

            setState(() {});
          },
        ),
      );
    });
  }
}
