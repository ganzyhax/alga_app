import 'dart:developer';

import 'package:alga_app/app/api/api_client.dart';
import 'package:alga_app/app/screens/driver/bloc/driver_bloc.dart';
import 'package:alga_app/app/socket/passanger_socket_manager.dart';
import 'package:alga_app/constants/app_constant.dart';
import 'package:bloc/bloc.dart';

part 'passanger_event.dart'; // Correct reference to the event part
part 'passanger_state.dart'; // Correct reference to the state part

class PassengerBloc extends Bloc<PassengerEvent, PassengerState> {
  PassengerSocketManager? socketManager; // Only instantiate when needed

  PassengerBloc() : super(PassengerInitial()) {
    var currentOrderData;
    var isSearchingOrder = false;
    on<PassengerEvent>((event, emit) async {
      socketManager = PassengerSocketManager();
      socketManager!.connectAndRegisterPassenger('670a932dcf2d855a4938987d');
      socketManager!.orderResponseStream.listen((data) {
        currentOrderData = data;
        add(PassengerOrderResponse(data));
      });
      socketManager!.orderArrivedController.listen((data) {
        currentOrderData = data['orderId'];
        add(PassengerOngoingOrder(data: data));
      });
      socketManager!.orderCompletingController.listen((data) {
        currentOrderData = data['orderId'];
        add(PassengerOrderResponse(data));
      });
      if (event is PassengerLoad) {
        emit(PassengerLoaded(
            currentOrderData: currentOrderData,
            isSearchingOrder: isSearchingOrder));
      }
      if (event is PassangerCreateOrder) {
        // Send order creation request
        final response = await ApiClient.post(
          'api/passanger/create-order',
          {
            "pickupLocation": {
              "type": "Point",
              "coordinates": [71.4340, 51.1291] // Expo 2017
            },
            "dropoffLocation": {
              "type": "Point",
              "coordinates": [71.4272, 51.1424] // Khan Shatyr
            },
            "orderType": "Econom",
            "fare": 25.50
          },
          lToken:
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MGE5MzJkY2YyZDg1NWE0OTM4OTg3ZCIsInVzZXJJZCI6IjY3MGE5MzJkY2YyZDg1NWE0OTM4OTg3ZCIsImlhdCI6MTcyOTAwNjE3NSwiZXhwIjoxNzI5MDkyNTc1fQ.eQGfx-vsiR8iaHQul6PSNabQVATIkdSPfp79ypBLFI0',
        );

        currentOrderData = response['data'];
        isSearchingOrder = true;
        // Handle API response here if needed
        emit(PassengerLoaded(
            currentOrderData: currentOrderData,
            isSearchingOrder: isSearchingOrder));
      }
      if (event is PassengerOrderResponse) {
        if (event.orderData != null) {
          emit(PassengerOrderConfirmed(orderData: event.orderData));
        } else {
          emit(PassengerOrderFailed(
              'No drivers available or an error occurred.'));
        }

        // Disconnect the socket if order fails or completes
        socketManager?.dispose();
      }
      if (event is PassengerOngoingOrder) {
        // Handle ongoing order here
        emit(PassengerOrderConfirmed(orderData: event.data));

        // Optionally keep the socket alive until the order completes
      }
      if (event is PassengerCancelOrder) {
        // Optionally, you can call an API to cancel the order on the server
        log(currentOrderData['order']['_id']);
        await ApiClient.post('api/passanger/cancel-order',
            {'orderId': currentOrderData['order']['_id']},
            lToken:
                'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MGE5MzJkY2YyZDg1NWE0OTM4OTg3ZCIsInVzZXJJZCI6IjY3MGE5MzJkY2YyZDg1NWE0OTM4OTg3ZCIsImlhdCI6MTcyODkxOTU4NiwiZXhwIjoxNzI5MDA1OTg2fQ.jUCyUvLYc8kHa-FB1_XA23foFBov8T0LyB6djuMSRfw');
        currentOrderData = null;
        // Emit initial state after canceling
        emit(PassengerInitial());
      }
    });
  }

  @override
  Future<void> close() {
    socketManager?.dispose(); // Ensure the socket is disposed on bloc close
    return super.close();
  }
}
