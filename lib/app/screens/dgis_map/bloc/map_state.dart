part of 'map_bloc.dart';

@immutable
sealed class MapState {}

final class MapInitial extends MapState {}

final class MapLoaded extends MapState {
  MapLoaded();
}
