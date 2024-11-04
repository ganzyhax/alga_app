import 'package:geolocator/geolocator.dart';

abstract class DGisMapEvent {}

class DGisMapLoad extends DGisMapEvent {
  final List<double> aPoint;
  final List<double> bPoint;
  DGisMapLoad({required this.aPoint, required this.bPoint});
}

class DGisMapChangeRoute extends DGisMapEvent {
  final List<double> aPoint;
  final List<double> bPoint;
  DGisMapChangeRoute({required this.aPoint, required this.bPoint});
}
