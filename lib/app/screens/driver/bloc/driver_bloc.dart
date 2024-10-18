import 'dart:developer';

import 'package:alga_app/app/socket/driver_socket_manager.dart';
import 'package:bloc/bloc.dart';
part 'driver_event.dart';
part 'driver_state.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {
  late OrderSocketManager socketManager;
  var currentOrderData;
  DriverBloc() : super(DriverInitial()) {
    socketManager = OrderSocketManager();
    socketManager.newOrderStream.listen((data) {
      add(DriverNewOrder(data));
    });

    on<DriverEvent>((event, emit) async {
      if (event is DriverLoad) {
        emit(DriverLoaded(currentOrderData: currentOrderData));
      }
      if (event is DriverNewOrder) {
        currentOrderData = event.orderData;
        emit(DriverLoaded(currentOrderData: event.orderData));
      }
      if (event is AcceptOrderEvent) {
        socketManager.acceptOrder(event.orderId);
        currentOrderData['status'] = 'accepted';
        emit(DriverLoaded(currentOrderData: currentOrderData));
      }
      if (event is RejectOrderEvent) {
        emit(DriverOrderRejected());
      }
    });
    @override
    Future<void> close() {
      socketManager.dispose();
      return super.close();
    }
  }
}
