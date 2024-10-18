import 'dart:async';
import 'dart:developer';
import 'package:alga_app/constants/app_constant.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class OrderSocketManager {
  late IO.Socket socket;
  final StreamController<dynamic> _newOrderController =
      StreamController.broadcast();

  OrderSocketManager() {
    _initializeSocket();
  }

  void _initializeSocket() {
    socket = IO.io(AppConstant.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      log('Connected successfully to server');
      socket.emit('registerDriver', '670a5ba9b1c8f9cb4b0a1b8f');
    });

    socket.on('newOrder', (data) {
      _newOrderController.add(data);
    });

    socket.on('orderCanceled', (data) {
      log('Order cancalled');
    });
  }

  void acceptOrder(String orderId) {
    socket.emit('accept', orderId);
  }

  void rejectOrder(String orderId) {
    socket.emit('reject', orderId);
  }

  void arrivedOrder(String orderId) {
    socket.emit('arrived', orderId);
  }

  void completingOrder(String orderId) {
    socket.emit('completing', orderId);
  }

  void completedOrder(String orderId) {
    socket.emit('completed', orderId);
  }

  Stream<dynamic> get newOrderStream => _newOrderController.stream;

  void dispose() {
    socket.dispose();
    _newOrderController.close();
  }
}
