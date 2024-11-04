part of 'passanger_bloc.dart';

abstract class PassengerState {}

class PassengerInitial extends PassengerState {}

class PassengerLoaded extends PassengerState {
  final currentOrderData;
  final bool isSearchingOrder;
  final addressA;
  final addressB;
  final orderType;
  final fare;
  final currentOrderDuration;
  final payType;
  PassengerLoaded(
      {required this.addressA,
      required this.currentOrderData,
      required this.isSearchingOrder,
      required this.addressB,
      required this.orderType,
      required this.fare,
      required this.currentOrderDuration,
      required this.payType});
}

class PassengerOrderLoading extends PassengerState {}

class PassengerOrderConfirmed extends PassengerState {
  final dynamic orderData;

  PassengerOrderConfirmed({required this.orderData});
}

class PassengerOrderFailed extends PassengerState {
  final String message;

  PassengerOrderFailed(this.message);
}
