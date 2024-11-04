import 'dart:async';
import 'dart:developer';
import 'package:geolocator/geolocator.dart';

class LocationServices {
  static final LocationServices _instance = LocationServices._internal();
  factory LocationServices() => _instance;
  LocationServices._internal();

  Position? _currentPosition;
  StreamController<Position> _positionStreamController =
      StreamController<Position>.broadcast();
  Timer? _timer;

  void startLocationUpdates() {
    _timer?.cancel(); // Cancel any existing timers
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) async {
      try {
        Position position = await getCurrentLocation();
        _currentPosition = position;
        log(_currentPosition!.latitude.toString());
        _positionStreamController.add(position);
      } catch (e) {
        print('Error getting location: $e');
      }
    });
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Position? get currentPosition => _currentPosition;

  Stream<Position> get positionStream => _positionStreamController.stream;

  void stopLocationUpdates() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    _timer?.cancel();
    _positionStreamController.close();
  }
}
