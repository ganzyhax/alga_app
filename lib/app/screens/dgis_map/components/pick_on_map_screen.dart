import 'dart:async';
import 'dart:developer';
import 'package:alga_app/app/screens/dgis_map/functions/map_functions.dart';
import 'package:alga_app/app/widgets/buttons/custom_button.dart';
import 'package:alga_app/constants/app_colors.dart';
import 'package:dgis_mobile_sdk_full/dgis.dart' as sdk;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Geolocator package for location

class PickOnMapScreen extends StatefulWidget {
  const PickOnMapScreen({super.key});

  @override
  _PickOnMapScreenState createState() => _PickOnMapScreenState();
}

class _PickOnMapScreenState extends State<PickOnMapScreen> {
  sdk.MapWidgetController? _mapWidgetController;
  sdk.Map? _sdkMap;
  late sdk.Context _sdkContext;
  late sdk.MapObjectManager mapObjectManager;
  late sdk.ImageLoader loader;
  sdk.CameraPosition? _currentCameraPosition;
  Timer? _debounceTimer;
  List pickedLocation = [];
  String pickedAddress = '';

  @override
  void initState() {
    super.initState();

    _sdkContext = sdk.DGis.initialize();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapWidgetController?.getMapAsync((map) {
        _sdkMap = map;
        mapObjectManager = sdk.MapObjectManager(_sdkMap!);
        loader = sdk.ImageLoader(_sdkContext); // Initialize the image loader

        // Subscribe to camera position changes
        _sdkMap?.camera.positionChannel.listen((position) {
          _currentCameraPosition = position; // Update current camera position

          // Cancel previous timer if it exists
          _debounceTimer?.cancel();

          // Start a new timer
          _debounceTimer = Timer(const Duration(milliseconds: 300), () {
            // This code will run after the camera has stopped moving for 300 ms
            pickedLocation = [
              position.point.latitude.value,
              position.point.longitude.value
            ];
            _updatePickedAddress(
                position.point.latitude.value, position.point.longitude.value);
          });
        });
      });
    });

    _initLocationService();
  }

// Define a separate async method for the geocoding
  Future<void> _updatePickedAddress(double latitude, double longitude) async {
    pickedAddress = await DGisMapFunctions(sdkMap: _sdkMap)
        .geocoderLocation(latitude, longitude);
    pickedLocation = [latitude, longitude];
    setState(() {});

    // Optionally call setState if you need to update the UI based on pickedAddress
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

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _updatePickedAddress(position.latitude, position.longitude);
    if (_sdkMap != null) {
      DGisMapFunctions(sdkMap: _sdkMap)
          .moveCameraToLocation(position.latitude, position.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios_new_outlined)),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.23,
                margin: EdgeInsets.only(left: 15),
                decoration: BoxDecoration(color: AppColors.secondary),
                padding: EdgeInsets.all(10),
                child: Text(pickedAddress, style: TextStyle(fontSize: 17)),
              ),
            ),
            SizedBox()
          ],
        ),
      ),
      body: Stack(
        children: [
          sdk.MapWidget(
            sdkContext: _sdkContext,
            mapOptions: sdk.MapOptions(),
            controller: _mapWidgetController = sdk.MapWidgetController(),
          ),
          // Center icon for selecting location
          Positioned(
            left:
                MediaQuery.of(context).size.width / 2.2, // Center horizontally
            top: MediaQuery.of(context).size.height / 2.5, // Center vertically
            child: Row(
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 48, // Size of the icon
                      color: Colors.red, // Color of the icon
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  backgroundColor: AppColors.secondary,
                  onPressed: () async {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    DGisMapFunctions(sdkMap: _sdkMap).moveCameraToLocation(
                        position.latitude, position.longitude);
                  },
                  child: const Icon(Icons.location_on_outlined),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width -
                      32, // Full width minus padding
                  child: CustomButton(
                    text: 'Выбрать',
                    onTap: () {
                      Navigator.pop(context, {
                        'location': pickedLocation,
                        'address': pickedAddress
                      });
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
