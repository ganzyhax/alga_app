import 'dart:developer';

import 'package:dgis_mobile_sdk_full/dgis.dart' as sdk;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DGisMapFunctions {
  DGisMapFunctions({required this.sdkMap});
  sdk.Map? sdkMap;

  void moveCameraToLocation(double? lat, lon) async {
    final sdk.GeoPoint target = sdk.GeoPoint(
      latitude: sdk.Latitude(lat!),
      longitude: sdk.Longitude(lon),
    );
    sdkMap?.camera.move(target, sdk.Zoom(16), sdk.Tilt(0), sdk.Bearing(0),
        const Duration(milliseconds: 500), sdk.CameraAnimationType.linear);
  }

  Future<String> geocoderLocation(double lat, lon) async {
    final String url =
        'https://catalog.api.2gis.com/3.0/items/geocode?lat=$lat&lon=$lon&fields=items.point&key=c3605b1b-3136-410e-b92b-ddb5a1612c3d';

    try {
      final response = await http.get(Uri.parse(url));

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
      return 'Astana';
    }
  }

  Future<List<dynamic>> getLocationCoordinate() async {
    // Check location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {}
    }
    Position position = await Geolocator.getCurrentPosition();
    return [position.latitude, position.longitude];
  }
}
