import 'dart:developer';

import 'package:dgis_mobile_sdk_full/dgis.dart' as sdk;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DGisMapFunctions {
  DGisMapFunctions({required this.sdkMap});
  sdk.Map? sdkMap;

  void moveCameraToLocation(double? lat, lon, {double? zoom = 17}) async {
    final sdk.GeoPoint target = sdk.GeoPoint(
      latitude: sdk.Latitude(lat!),
      longitude: sdk.Longitude(lon),
    );
    log('Moving camera');
    sdkMap?.camera.move(
      target,
      sdk.Zoom(
        (zoom == null) ? 17 : zoom,
      ),
      sdk.Tilt(10),
      sdk.Bearing(0),
      const Duration(milliseconds: 0),
    );
  }

  List<double> getPointsCenterCoordinate(
      List<double> aPoint, List<double> bPoint) {
    final sdk.GeoPoint point1 = sdk.GeoPoint(
      latitude: sdk.Latitude(aPoint[0]),
      longitude: sdk.Longitude(aPoint[1]),
    );
    final sdk.GeoPoint point2 = sdk.GeoPoint(
      latitude: sdk.Latitude(bPoint[0]),
      longitude: sdk.Longitude(bPoint[1]),
    );

// Calculate the midpoint
    final double midLatitude =
        (point1.latitude.value + point2.latitude.value) / 2;
    final double midLongitude =
        (point1.longitude.value + point2.longitude.value) / 2;
    final sdk.GeoPoint midpoint = sdk.GeoPoint(
      latitude: sdk.Latitude(midLatitude),
      longitude: sdk.Longitude(midLongitude),
    );

// Estimate zoom level based on the distance (you may need to adjust this)
    final double zoomLevel = 12.0; // Adjust as needed

// Set the camera position to the midpoint
    final sdk.CameraPosition cameraPosition = sdk.CameraPosition(
      point: midpoint,
      zoom: sdk.Zoom(zoomLevel),
      tilt: sdk.Tilt(15), // Adjust tilt if needed
      bearing: sdk.Bearing(0), // Optional, adjust if necessary
    );
    return [
      cameraPosition.point.latitude.value,
      cameraPosition.point.longitude.value,
    ];
  }

  Future<String> geocoderLocation(double lat, lon) async {
    final String url =
        'https://catalog.api.2gis.com/3.0/items/geocode?lat=$lat&lon=$lon&fields=items.point&key=75021d7b-e60e-472f-82f0-63b0c4d2a038';

    try {
      final response = await http.get(Uri.parse(url));
      log(response.body.toString());
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON.
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['result']['items'][0].containsKey('address_name')) {
          return data['result']['items'][0]['address_name'];
        } else {
          return data['result']['items'][0]['full_name'];
        }
      } else {
        return 'Астана';
      }
    } catch (e) {
      log(e.toString());
      return 'Astana';
    }
  }

  Future<List<dynamic>> getLocationCoordinate() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {}
    }
    Position position = await Geolocator.getCurrentPosition();
    return [position.latitude, position.longitude];
  }

  Future<Map<String, dynamic>> getAandBLinesData(
      sdk.Context _sdkContext, List<double> aPoint, List<double> bPoint) async {
    final sdk.RouteSearchPoint pointA = sdk.RouteSearchPoint(
      coordinates: sdk.GeoPoint(
        latitude: sdk.Latitude(aPoint[0]), // Координаты в Астане
        longitude: sdk.Longitude(aPoint[1]),
      ),
    );

    final sdk.RouteSearchPoint pointB = sdk.RouteSearchPoint(
      coordinates: sdk.GeoPoint(
        latitude: sdk.Latitude(bPoint[0]), // Координаты в Астане
        longitude: sdk.Longitude(bPoint[1]),
      ),
    );

    final sdk.RouteSearchOptions routeSearchOptions =
        sdk.RouteSearchOptions.taxi(
      sdk.TaxiRouteSearchOptions(sdk.CarRouteSearchOptions()),
    );

    final sdk.TrafficRouter trafficRouter = sdk.TrafficRouter(_sdkContext);
    final List<sdk.TrafficRoute> routes =
        await trafficRouter.findRoute(pointA, pointB, routeSearchOptions).value;

    if (routes.isNotEmpty) {
      final sdk.TrafficRoute route = routes.first;

      final List<sdk.GeoPointRouteEntry> entries = route.route.geometry.entries;
      final List<sdk.GeoPoint> polylinePoints = entries.map((entry) {
        return entry.value; // Получаем GeoPoint из GeoPointRouteEntry
      }).toList();

      return {
        'routePolyline': polylinePoints,
        'routeTime': route.traffic.durations
            .duration, // Get the actual duration from the route
      };
    } else {
      return {
        'routePolyline': [],
        'routeTime': '0',
      };
    }
  }
}
