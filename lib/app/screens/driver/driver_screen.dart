import 'dart:developer';

import 'package:alga_app/app/screens/driver/bloc/driver_bloc.dart';
import 'package:alga_app/app/screens/driver/widgets/driver_completing_order_container.dart';
import 'package:alga_app/app/screens/driver/widgets/driver_new_order_container.dart';
import 'package:alga_app/app/screens/driver/widgets/driver_searching_order_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class DriverScreen extends StatefulWidget {
  @override
  _DriverScreenState createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<DriverBloc, DriverState>(
        listener: (context, state) {},
        child: BlocBuilder<DriverBloc, DriverState>(
          builder: (context, state) {
            if (state is DriverLoaded) {
              return Stack(
                children: [
                  Center(
                    child: Text("Map"),
                  ),
                  (state.currentOrderData != null)
                      ? (state.currentOrderData['status'] == 'pending')
                          ? DriverNewOrderContainer(
                              orderData: state.currentOrderData,
                            )
                          : (state.currentOrderData['status'] == 'accepted')
                              ? DriverCompletingOrderContainer()
                              : SizedBox()
                      : DriverSearchingOrderContainer()
                ],
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
