import 'dart:async';
import 'dart:developer';
import 'package:alga_app/constants/app_constant.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PassengerSocketManager {
  late IO.Socket socket;
  final StreamController<dynamic> _orderResponseController =
      StreamController.broadcast();
  final StreamController<dynamic> _orderArrivedController =
      StreamController.broadcast();
  final StreamController<dynamic> _orderCompletingController =
      StreamController.broadcast();
  final StreamController<dynamic> _orderCompletedController =
      StreamController.broadcast();

  PassengerSocketManager() {
    _initializeSocket();
  }

  void _initializeSocket() {
    socket = IO.io(AppConstant.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.on('accepted', (data) {
      log('Driver accepted: $data');
      _orderResponseController.add(data);
    });
    socket.on('arrived', (data) {
      log('Driver arrived: $data');
      _orderArrivedController.add(data);
    });
    socket.on('completing', (data) {
      log('Driver started: $data');
      _orderCompletingController.add(data);
    });

    socket.on('completed', (data) {
      log('Driver accepted: $data');
      _orderCompletedController.add(data);
    });

    socket.onDisconnect((_) {
      log('Disconnected from server');
    });
  }

  void connectAndRegisterPassenger(String passengerId) {
    socket.connect();
    socket.onConnect((_) {
      log('Connected successfully to server');
      socket.emit('registerPassenger', passengerId);
    });
  }

  Stream<dynamic> get orderResponseStream => _orderResponseController.stream;
  Stream<dynamic> get orderArrivedController => _orderArrivedController.stream;

  Stream<dynamic> get orderCompletingController =>
      _orderCompletingController.stream;
  Stream<dynamic> get orderCompletedController =>
      _orderCompletedController.stream;

  void dispose() {
    socket.dispose();
    _orderResponseController.close();
    _orderArrivedController.close();
    _orderCompletingController.close();
    _orderCompletedController.close();
  }
}
