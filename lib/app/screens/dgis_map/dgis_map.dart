import 'dart:developer';

import 'package:dgis_mobile_sdk_full/dgis.dart' as sdk;
import 'package:flutter/material.dart';
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

    // Initialize DGis SDK context
    _sdkContext = sdk.DGis.initialize();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapWidgetController?.getMapAsync((map) {
        _sdkMap = map;
        mapObjectManager = sdk.MapObjectManager(_sdkMap!);
        loader = sdk.ImageLoader(_sdkContext); // Initialize the image loader
      });
    });
    // Fetch the current location
    _initLocationService();

    // Wait for the map to be initialized and then access it
  }

  // Initialize the location service and get the current location using Geolocator
  Future<void> _initLocationService() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, return early.
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return;
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, handle appropriately.
        return;
      }
    }

    // Fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Move the camera to the user's current location
    if (_sdkMap != null) {
      _addMarker(
        position.latitude,
        position.longitude,
        "assets/images/location.png",
      );
      _moveCameraToLocation(position.latitude, position.longitude);
    }
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

  // Function to move the camera to the user's location
  void _moveCameraToLocation(double? lat, lon) async {
    final sdk.GeoPoint target = sdk.GeoPoint(
      latitude: sdk.Latitude(lat!),
      longitude: sdk.Longitude(lon),
    );

    // Create marker options

    // Create and add the marker to the map
    _sdkMap?.camera.move(target, sdk.Zoom(16), sdk.Tilt(0), sdk.Bearing(0),
        const Duration(milliseconds: 500), sdk.CameraAnimationType.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sdk.MapWidget(
        sdkContext: _sdkContext,
        mapOptions: sdk.MapOptions(),
        controller: _mapWidgetController = sdk.MapWidgetController(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Fetch the current location when the button is pressed
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);

          _moveCameraToLocation(position.latitude, position.longitude);
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
