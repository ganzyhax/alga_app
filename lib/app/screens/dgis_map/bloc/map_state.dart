part of 'map_bloc.dart';

@immutable
sealed class MapState {}

final class MapInitial extends MapState {}

final class MapLoaded extends MapState {
  sdk.Context sdkContext;
  sdk.Map map;
  sdk.MapWidgetController mapWidgetController;
  MapLoaded(
      {required this.sdkContext,
      required this.map,
      required this.mapWidgetController});
}
