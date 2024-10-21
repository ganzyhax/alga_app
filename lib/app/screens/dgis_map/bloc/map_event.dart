part of 'map_bloc.dart';

@immutable
sealed class MapEvent {}

final class MapLoad extends MapEvent {}

final class MapChangeLocation extends MapEvent {
  final double lat;
  final double long;
  MapChangeLocation({required this.lat, required this.long});
}
