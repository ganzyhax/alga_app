import 'package:geolocator/geolocator.dart';

abstract class DGisMapState {}

class DGisMapLoaded extends DGisMapState {
  final List<double> aPoint;
  final List<double> bPoint;
  bool isInitialize;

  DGisMapLoaded(
      {required this.aPoint, required this.bPoint, required this.isInitialize});
}

class DGisMapInitial extends DGisMapState {}
