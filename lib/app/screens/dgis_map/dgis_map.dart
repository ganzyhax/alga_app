import 'dart:developer';

import 'package:alga_app/app/screens/dgis_map/bloc/map_bloc.dart';
import 'package:alga_app/app/screens/dgis_map/bloc/map_state.dart';
import 'package:alga_app/app/screens/dgis_map/functions/map_functions.dart';
import 'package:alga_app/app/screens/passanger/bloc/passanger_bloc.dart';
import 'package:dgis_mobile_sdk_full/dgis.dart' as sdk;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart'; // Geolocator package for location

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
  bool mapLoaded = false;
  late sdk.GeoPoint centerPoint;
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
    setState(() {
      mapLoaded = true; // Update state to indicate the map is loaded
    });
    // _initLocationService();
  }

  Future<void> _initLocationService() async {
    bool serviceEnabled;
    LocationPermission permission;
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

    Position position = await Geolocator.getCurrentPosition();

    if (_sdkMap != null) {
      DGisMapFunctions(sdkMap: _sdkMap)
          .moveCameraToLocation(position.latitude, position.longitude);
      setState(() {
        mapLoaded = true; // Update state to indicate the map is loaded
      });
    } else {
      log('NUll');
    }
  }

  void _addMarker(double? lat, lon, String asset, {String? duration}) async {
    int size = (asset == 'assets/images/location_a.png') ? 50 : 85;
    final sdk.Image icon = await loader.loadPngFromAsset(asset, size, size);

    final sdk.MarkerOptions markerOptions = sdk.MarkerOptions(
        position: sdk.GeoPointWithElevation(
          latitude: sdk.Latitude(lat!),
          longitude: sdk.Longitude(lon),
        ),
        icon: icon,
        text: (asset == 'assets/images/location_b.png')
            ? duration.toString() + ' мин'
            : null,
        textStyle: (asset == 'assets/images/location_b.png')
            ? sdk.TextStyle(
                textPlacement: sdk.TextPlacement.topCenter,
                strokeWidth: sdk.LogicalPixel(4),
                fontSize: sdk.LogicalPixel(14),
                color: sdk.Color(4294967295),
                strokeColor: sdk.Color(4278190080),
              )
            : null);
    final sdk.Marker marker = sdk.Marker(markerOptions);
    mapObjectManager.addObject(marker);
  }

  void addRoute(List<double> aPoint, bPoint) async {
    var polylinePoints = await DGisMapFunctions(sdkMap: _sdkMap)
        .getAandBLinesData(_sdkContext, aPoint, bPoint);
    GetIt.instance<PassengerBloc>()
      ..add(PassangerSetRouteDuration(duration: polylinePoints['routeTime']));
    _addMarker(aPoint[0], aPoint[1], 'assets/images/location_a.png');
    _addMarker(bPoint[0], bPoint[1], 'assets/images/location_b.png',
        duration: (polylinePoints['routeTime'].inMinutes + 1).toString());
    final sdk.Polyline polyline = sdk.Polyline(
      sdk.PolylineOptions(
        points: polylinePoints['routePolyline'], // Точки маршрута
        width: sdk.LogicalPixel(2.5), // Ширина линии
      ),
    );
    mapObjectManager.addObject(polyline);

    final sdk.Geometry geometry = sdk.ComplexGeometry([
      sdk.PointGeometry(sdk.GeoPoint(
          latitude: sdk.Latitude(aPoint[0]),
          longitude: sdk.Longitude(aPoint[1]))),
      sdk.PointGeometry(sdk.GeoPoint(
          latitude: sdk.Latitude(bPoint[0]),
          longitude: sdk.Longitude(bPoint[1]))),
    ]);
    sdk.CameraPosition position = sdk.calcPositionForGeometry(
      _sdkMap!.camera,
      geometry,
      null,
      sdk.Padding(
          top: 40,
          bottom: (MediaQuery.of(context).size.height / 2.2).toInt(),
          left: 20,
          right: 20),
      sdk.Tilt(1),
      sdk.Bearing(0),
      sdk.ScreenSize(
          width: MediaQuery.of(context).size.width.toInt(),
          height: MediaQuery.of(context).size.height.toInt()),
    );
    centerPoint = position.point;
    _sdkMap!.camera.move(position.point, sdk.Zoom(14), null, sdk.Bearing(0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<DGisMapBloc, DGisMapState>(
        listener: (context, state) async {
          if (state is DGisMapLoaded) {
            if (!state.isInitialize) {
              mapObjectManager.removeAll();
            }
            addRoute([state.aPoint[0], state.aPoint[1]],
                [state.bPoint[0], state.bPoint[1]]);
          }
        },
        child: BlocBuilder<PassengerBloc, PassengerState>(
          builder: (context, state) {
            if (state is PassengerLoaded) {
              return sdk.MapWidget(
                  sdkContext: _sdkContext,
                  mapOptions: sdk.MapOptions(),
                  controller: _mapWidgetController = sdk.MapWidgetController(),
                  child: (mapLoaded)
                      ? Positioned(
                          bottom: MediaQuery.of(context).size.height / 2.4,
                          right: 10,
                          child: GestureDetector(
                            onTap: () {
                              if (centerPoint != null) {
                                _sdkMap!.camera.move(centerPoint, sdk.Zoom(14),
                                    null, sdk.Bearing(0));
                              }
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Center(
                                    child: Icon(
                                  Icons.gesture,
                                  size: 22,
                                )),
                              ),
                            ),
                          ))
                      : Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    'assets/images/map_placeholder.png',
                                  ))),
                        ));
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
