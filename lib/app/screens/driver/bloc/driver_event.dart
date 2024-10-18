part of 'driver_bloc.dart';

abstract class DriverEvent {
  @override
  List<Object> get props => [];
}

class DriverNewOrder extends DriverEvent {
  final dynamic orderData; // Adjust the type according to your data structure

  DriverNewOrder(this.orderData);

  @override
  List<Object> get props => [orderData];
}

class AcceptOrderEvent extends DriverEvent {
  final String orderId;

  AcceptOrderEvent(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class RejectOrderEvent extends DriverEvent {
  final String orderId;

  RejectOrderEvent(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class DriverOngoingOrder extends DriverEvent {
  final data;
  DriverOngoingOrder({required this.data});
}

class DriverLoad extends DriverEvent {}
