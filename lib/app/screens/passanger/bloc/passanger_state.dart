part of 'passanger_bloc.dart';

abstract class PassengerState {}

class PassengerInitial extends PassengerState {}

class PassengerOrderLoading extends PassengerState {}

class PassengerOrderConfirmed extends PassengerState {
  final dynamic orderData;

  PassengerOrderConfirmed({required this.orderData});
}

class PassengerOrderFailed extends PassengerState {
  final String message;

  PassengerOrderFailed(this.message);
}
