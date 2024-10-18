import 'dart:async';

import 'package:alga_app/app/screens/driver/bloc/driver_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverNewOrderContainer extends StatefulWidget {
  final orderData;
  const DriverNewOrderContainer({super.key, required this.orderData});

  @override
  State<DriverNewOrderContainer> createState() =>
      _DriverNewOrderContainerState();
}

class _DriverNewOrderContainerState extends State<DriverNewOrderContainer> {
  Timer? _orderTimer;
  int _timeLeft = 10;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              spreadRadius: 5.0,
              offset: Offset(0, -5),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "New Order Details:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Pickup Location: ${widget.orderData['pickupLocation']}"),
            SizedBox(height: 5),
            Text("Dropoff Location: ${widget.orderData['dropoffLocation']}"),
            SizedBox(height: 5),
            Text("Fare: \$${widget.orderData['fare']}"),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<DriverBloc>(context).add(
                      AcceptOrderEvent(widget.orderData['orderId']),
                    );
                    _cancelTimer();
                  },
                  child: Text("Accept"),
                ),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<DriverBloc>(context).add(
                      RejectOrderEvent(widget.orderData['orderId']),
                    );
                    _cancelTimer();
                  },
                  child: Text("Reject"),
                ),
                Spacer(),
                Text("Time left: $_timeLeft s",
                    style: TextStyle(color: Colors.red)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Start the order acceptance timer
  void _startOrderTimer(BuildContext context, String orderId) {
    setState(() {
      _timeLeft = 10;
    });

    _orderTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _cancelTimer();
        // Automatically reject the order if time runs out
        BlocProvider.of<DriverBloc>(context).add(RejectOrderEvent(orderId));
        setState(() {});
      }
    });
  }

  // Cancel the timer when the order is accepted or rejected
  void _cancelTimer() {
    if (_orderTimer != null) {
      _orderTimer!.cancel();
      _orderTimer = null;
    }
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
