import 'dart:developer';

import 'package:alga_app/app/screens/dgis_map/bloc/map_event.dart';
import 'package:alga_app/app/screens/dgis_map/bloc/map_state.dart';
import 'package:alga_app/app/screens/dgis_map/functions/map_functions.dart';
import 'package:dgis_mobile_sdk_full/dgis.dart' as sdk;
import 'package:flutter_bloc/flutter_bloc.dart';

class DGisMapBloc extends Bloc<DGisMapEvent, DGisMapState> {
  DGisMapBloc() : super(DGisMapInitial()) {
    List<double> pointA;
    List<double> pointB;
    on<DGisMapEvent>((event, emit) async {
      if (event is DGisMapLoad) {
        pointA = event.aPoint;
        pointB = event.bPoint;

        emit(DGisMapLoaded(aPoint: pointA, bPoint: pointB, isInitialize: true));
      }
      if (event is DGisMapChangeRoute) {
        emit(DGisMapLoaded(
            aPoint: event.aPoint, bPoint: event.bPoint, isInitialize: false));
      }
    });
  }
}
