import 'package:alga_app/app/screens/driver/bloc/driver_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class DriverScreen extends StatefulWidget {
  @override
  _DriverScreenState createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  Timer? _orderTimer;
  int _timeLeft = 10; // Set the timer for accepting an order
  bool _hasActiveOrder = false; // Tracks if an order is active

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DriverBloc(),
      child: Scaffold(
        body: BlocListener<DriverBloc, DriverState>(
          listener: (context, state) {
            if (state is DriverReceiveNewOrder) {
              // Start timer when a new order is received
              _hasActiveOrder = true;
              _startOrderTimer(context, state.orderData['orderId']);
            } else if (state is DriverOrderRejected) {
              // Stop showing the order when it's rejected
              _hasActiveOrder = false;
            }
          },
          child: Stack(
            children: [
              Center(
                child: Text("Map"),
              ),
              BlocBuilder<DriverBloc, DriverState>(
                builder: (context, state) {
                  // Show the order details if an order is received
                  if (state is DriverReceiveNewOrder && _hasActiveOrder) {
                    return Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16.0)),
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
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                                "Pickup Location: ${state.orderData['pickupLocation']}"),
                            SizedBox(height: 5),
                            Text(
                                "Dropoff Location: ${state.orderData['dropoffLocation']}"),
                            SizedBox(height: 5),
                            Text("Fare: \$${state.orderData['fare']}"),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    BlocProvider.of<DriverBloc>(context).add(
                                      AcceptOrderEvent(
                                          state.orderData['orderId']),
                                    );
                                    _cancelTimer();
                                  },
                                  child: Text("Accept"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    BlocProvider.of<DriverBloc>(context).add(
                                      RejectOrderEvent(
                                          state.orderData['orderId']),
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
                  // Show "Searching for orders..." when no active order
                  else if (!_hasActiveOrder) {
                    return Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        height: MediaQuery.of(context).size.height / 4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              spreadRadius: 5.0,
                              offset: Offset(0, -5),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Searching for orders...",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Start the order acceptance timer
  void _startOrderTimer(BuildContext context, String orderId) {
    setState(() {
      _timeLeft = 30; // Reset the timer to 30 seconds
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
        setState(() {
          _hasActiveOrder = false; // No active order after timeout
        });
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
