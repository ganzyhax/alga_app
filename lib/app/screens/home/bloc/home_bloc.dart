import 'dart:developer';

import 'package:alga_app/app/screens/dgis_map/functions/map_functions.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    var locationData = {};
    on<HomeEvent>((event, emit) async {
      if (event is HomeLoad) {
        var locationCoordinate =
            await DGisMapFunctions(sdkMap: null).getLocationCoordinate();
        log(locationCoordinate.toString());
        String currentLocation =
            await DGisMapFunctions(sdkMap: null).geocoderLocation(
          locationCoordinate[0],
          locationCoordinate[1],
        );
        log(currentLocation.toString());
        locationData['location'] = locationCoordinate;
        locationData['address'] = currentLocation;

        emit(HomeLoaded(locationData: locationData));
      }
    });
  }
}
