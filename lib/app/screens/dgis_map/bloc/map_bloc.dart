import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:dgis_mobile_sdk_full/dgis.dart' as sdk;

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitial()) {
    final sdkContext = sdk.DGis.initialize();
    final sdk.MapWidgetController mapWidgetController =
        sdk.MapWidgetController();
    sdk.Map? sdkMap = null;

    on<MapEvent>((event, emit) {
      if (event is MapLoad) {
        mapWidgetController.getMapAsync((map) {
          sdkMap = map;
        });

        emit(MapLoaded(
            sdkContext: sdkContext,
            mapWidgetController: mapWidgetController,
            map: sdkMap!));
      }
    });
  }
}