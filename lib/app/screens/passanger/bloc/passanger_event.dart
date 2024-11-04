part of 'passanger_bloc.dart'; // Correctly reference passenger_bloc.dart

abstract class PassengerEvent {
  @override
  List<Object?> get props => [];
}

class PassangerCreateOrder extends PassengerEvent {}

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

class PassengerLoad extends PassengerEvent {
  final addressA;
  final addressB;
  PassengerLoad({required this.addressA, required this.addressB});
}

class PassangerSetRouteDuration extends PassengerEvent {
  final duration;
  PassangerSetRouteDuration({required this.duration});
}

class PassangerChangeFare extends PassengerEvent {
  String fareValue;
  PassangerChangeFare({required this.fareValue});
}

class PassangerChangeOrderType extends PassengerEvent {
  int orderType;
  PassangerChangeOrderType({required this.orderType});
}

class PassangerChangePaymentType extends PassengerEvent {
  int paymentType;
  PassangerChangePaymentType({required this.paymentType});
}

class PassangerChangeDurationTime extends PassengerEvent {
  var routeDuration;
  PassangerChangeDurationTime({required this.routeDuration});
}

class PassangerChangeAAddressDetails extends PassengerEvent {
  var aAddress;
  PassangerChangeAAddressDetails({required this.aAddress});
}

class PassangerChangeBAddressDetails extends PassengerEvent {
  var bAddress;
  PassangerChangeBAddressDetails({required this.bAddress});
}
