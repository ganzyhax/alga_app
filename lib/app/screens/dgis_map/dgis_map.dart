import 'dart:developer';

import 'package:alga_app/app/screens/dgis_map/bloc/map_bloc.dart';
import 'package:alga_app/app/screens/dgis_map/functions/map_functions.dart';
import 'package:dgis_mobile_sdk_full/dgis.dart' as sdk;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart'; // Geolocator package for location

class DGisMapScreen extends StatefulWidget {
  const DGisMapScreen({super.key});

  @override
  _DGisMapScreenState createState() => _DGisMapScreenState();
}

class _DGisMapScreenState extends State<DGisMapScreen> {
  sdk.MapWidgetController? _mapWidgetController;
  sdk.Map? _sdkMap;
  late sdk.Context _sdkContext;
  late sdk.MapObjectManager mapObjectManager;
  late sdk.ImageLoader loader;

  @override
  void initState() {
    super.initState();

    _sdkContext = sdk.DGis.initialize();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapWidgetController?.getMapAsync((map) {
        _sdkMap = map;
        mapObjectManager = sdk.MapObjectManager(_sdkMap!);
        loader = sdk.ImageLoader(_sdkContext); // Initialize the image loader
      });
    });

    _initLocationService();
  }

  Future<void> _initLocationService() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }

      if (permission == LocationPermission.denied) {
        return;
      }
    }

    // Position position = await Geolocator.getCurrentPosition();

    // if (_sdkMap != null) {
    //   _addMarker(
    //     position.latitude,
    //     position.longitude,
    //     "assets/images/location.png",
    //   );
    //   DGisMapFunctions(sdkMap: _sdkMap)
    //       .moveCameraToLocation(position.latitude, position.longitude);
    // }
  }

  void _addMarker(double? lat, lon, String asset) async {
    final sdk.Image icon = await loader.loadPngFromAsset(asset, 140, 140);

    final sdk.MarkerOptions markerOptions = sdk.MarkerOptions(
      position: sdk.GeoPointWithElevation(
        latitude: sdk.Latitude(lat!),
        longitude: sdk.Longitude(lon),
      ),
      icon: icon, // Use the loaded icon
    );
    final sdk.Marker marker = sdk.Marker(markerOptions);
    mapObjectManager.addObject(marker);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state is MapLoaded) {
            return sdk.MapWidget(
              sdkContext: _sdkContext,
              mapOptions: sdk.MapOptions(),
              controller: _mapWidgetController = sdk.MapWidgetController(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
