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
      socket.emit('registerDriver',
          '670a5ba9b1c8f9cb4b0a1b8f'); // Replace with actual driver ID
    });

    socket.on('newOrder', (data) {
      log(data.toString());
      _newOrderController.add(data);
    });

    socket.on('orderCanceled', (data) {
      log('Order cancalled');
    });
  }

  void acceptOrder(String orderId) {
    socket.emit('acceptOrder', orderId);
  }

  void rejectOrder(String orderId) {
    socket.emit('rejectOrder', orderId);
  }

  Stream<dynamic> get newOrderStream => _newOrderController.stream;

  void dispose() {
    socket.dispose();
    _newOrderController.close();
  }
}
