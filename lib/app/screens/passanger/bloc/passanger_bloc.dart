import 'dart:developer';

import 'package:alga_app/app/api/api_client.dart';
import 'package:alga_app/app/screens/driver/bloc/driver_bloc.dart';
import 'package:alga_app/app/socket/passanger_socket_manager.dart';
import 'package:alga_app/constants/app_constant.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart';

part 'passanger_event.dart';
part 'passanger_state.dart';

class PassengerBloc extends Bloc<PassengerEvent, PassengerState> {
  PassengerSocketManager? socketManager;

  PassengerBloc() : super(PassengerInitial()) {
    var currentOrderData;
    bool isSearchingOrder = false;
    var addressA;
    var addressB;
    String fare = '';
    int orderType = 0;
    int payType = 0;
    var currentOrderDuration;
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
        addressA = event.addressA;
        addressB = event.addressB;
        emit(PassengerLoaded(
            fare: fare,
            addressA: addressA,
            currentOrderDuration: currentOrderDuration,
            addressB: addressB,
            payType: payType,
            orderType: orderType,
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
              "coordinates": addressA['location'] // Expo 2017
            },
            "dropoffLocation": {
              "type": "Point",
              "coordinates": addressB['location'] // Khan Shatyr
            },
            "orderType": "Econom",
            "fare": fare
          },
          lToken:
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MGE5MzJkY2YyZDg1NWE0OTM4OTg3ZCIsInVzZXJJZCI6IjY3MGE5MzJkY2YyZDg1NWE0OTM4OTg3ZCIsImlhdCI6MTcyOTAwNjE3NSwiZXhwIjoxNzI5MDkyNTc1fQ.eQGfx-vsiR8iaHQul6PSNabQVATIkdSPfp79ypBLFI0',
        );

        currentOrderData = response['data'];
        isSearchingOrder = true;
        // Handle API response here if needed
        emit(PassengerLoaded(
            currentOrderDuration: currentOrderDuration,
            fare: fare,
            addressA: addressA,
            addressB: addressB,
            payType: payType,
            orderType: orderType,
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
        socketManager?.dispose();
      }
      if (event is PassengerOngoingOrder) {
        emit(PassengerOrderConfirmed(orderData: event.data));
      }
      if (event is PassengerCancelOrder) {
        log(currentOrderData['order']['_id']);
        await ApiClient.post('api/passanger/cancel-order',
            {'orderId': currentOrderData['order']['_id']},
            lToken:
                'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MGE5MzJkY2YyZDg1NWE0OTM4OTg3ZCIsInVzZXJJZCI6IjY3MGE5MzJkY2YyZDg1NWE0OTM4OTg3ZCIsImlhdCI6MTcyODkxOTU4NiwiZXhwIjoxNzI5MDA1OTg2fQ.jUCyUvLYc8kHa-FB1_XA23foFBov8T0LyB6djuMSRfw');
        currentOrderData = null;
        emit(PassengerInitial());
      }
      if (event is PassangerSetRouteDuration) {
        currentOrderDuration = event.duration;
        emit(PassengerLoaded(
            currentOrderDuration: currentOrderDuration,
            fare: fare,
            addressA: addressA,
            addressB: addressB,
            payType: payType,
            orderType: orderType,
            currentOrderData: currentOrderData,
            isSearchingOrder: isSearchingOrder));
      }
      if (event is PassangerChangePaymentType) {
        payType = event.paymentType;
        emit(PassengerLoaded(
            currentOrderDuration: currentOrderDuration,
            fare: fare,
            addressA: addressA,
            addressB: addressB,
            payType: payType,
            orderType: orderType,
            currentOrderData: currentOrderData,
            isSearchingOrder: isSearchingOrder));
      }
      if (event is PassangerChangeFare) {
        fare = event.fareValue;
        log(fare);
        emit(PassengerLoaded(
            currentOrderDuration: currentOrderDuration,
            fare: fare,
            addressA: addressA,
            addressB: addressB,
            payType: payType,
            orderType: orderType,
            currentOrderData: currentOrderData,
            isSearchingOrder: isSearchingOrder));
      }
      if (event is PassangerChangeAAddressDetails) {
        addressA = event.aAddress;
        emit(PassengerLoaded(
            currentOrderDuration: currentOrderDuration,
            fare: fare,
            addressA: addressA,
            addressB: addressB,
            payType: payType,
            orderType: orderType,
            currentOrderData: currentOrderData,
            isSearchingOrder: isSearchingOrder));
      }

      if (event is PassangerChangeBAddressDetails) {
        addressB = event.bAddress;
        emit(PassengerLoaded(
            currentOrderDuration: currentOrderDuration,
            fare: fare,
            addressA: addressA,
            addressB: addressB,
            payType: payType,
            orderType: orderType,
            currentOrderData: currentOrderData,
            isSearchingOrder: isSearchingOrder));
      }
      if (event is PassangerChangeOrderType) {
        orderType = event.orderType;
        emit(PassengerLoaded(
            currentOrderDuration: currentOrderDuration,
            fare: fare,
            addressA: addressA,
            addressB: addressB,
            payType: payType,
            orderType: orderType,
            currentOrderData: currentOrderData,
            isSearchingOrder: isSearchingOrder));
      }
    });
  }

  @override
  Future<void> close() {
    socketManager?.dispose(); // Ensure the socket is disposed on bloc close
    return super.close();
  }
}
