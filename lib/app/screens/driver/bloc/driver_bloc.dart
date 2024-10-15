import 'package:alga_app/app/socket/driver_socket_manager.dart';
import 'package:bloc/bloc.dart';
part 'driver_event.dart';
part 'driver_state.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {
  late OrderSocketManager socketManager;
  var currentOrder;
  DriverBloc() : super(DriverInitial()) {
    socketManager = OrderSocketManager();
    socketManager.newOrderStream.listen((data) {
      if (data['order'] != null && data['order']['status'] == 'accepted') {
        add(DriverOngoingOrder(data: data['order']));
        currentOrder = data['order'];
      } else {
        add(DriverNewOrder(data));
      }
    });

    on<DriverEvent>((event, emit) async {
      if (event is DriverNewOrder) {
        emit(DriverReceiveNewOrder(orderData: event.orderData));
      }
      if (event is AcceptOrderEvent) {
        socketManager.acceptOrder(event.orderId);
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
