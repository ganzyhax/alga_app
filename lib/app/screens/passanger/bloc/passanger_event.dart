part of 'passanger_bloc.dart'; // Correctly reference passenger_bloc.dart

abstract class PassengerEvent {
  @override
  List<Object?> get props => [];
}

class CreatePassengerOrder extends PassengerEvent {
  final List<double> pickupLocation;
  final List<double> dropoffLocation;
  final double fare;

  CreatePassengerOrder({
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.fare,
  });

  @override
  List<Object?> get props => [pickupLocation, dropoffLocation, fare];
}

class PassengerOrderResponse extends PassengerEvent {
  final dynamic orderData;

  PassengerOrderResponse(this.orderData);

  @override
  List<Object?> get props => [orderData];
}

class PassengerOngoingOrder extends PassengerEvent {
  final data;
  PassengerOngoingOrder({required this.data});
}

class PassengerCancelOrder extends PassengerEvent {
  // final String orderId;
  // PassengerCancelOrder({required this.orderId});
}
