part of 'driver_bloc.dart';

sealed class DriverState {}

final class DriverInitial extends DriverState {}

class DriverLoaded extends DriverState {
  final currentOrderData;
  DriverLoaded({required this.currentOrderData});
}

class DriverReceiveNewOrder extends DriverState {
  final orderData;
  DriverReceiveNewOrder({required this.orderData});
}

class DriverOrderRejected extends DriverState {}
