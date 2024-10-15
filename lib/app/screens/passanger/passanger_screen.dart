import 'package:alga_app/app/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alga_app/app/screens/passanger/bloc/passanger_bloc.dart';
import 'package:dgis_mobile_sdk_full/dgis.dart' as sdk;

class PassangerScreen extends StatelessWidget {
  const PassangerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sdkContext = sdk.DGis.initialize();
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Map Container Placeholder
            Container(
              width: MediaQuery.of(context).size.width,
              height:
                  MediaQuery.of(context).size.height, // Half of screen height
              decoration: BoxDecoration(
                color: Colors.grey[300], // Placeholder color for the map
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12),
              ),
              child: sdk.MapWidget(
                sdkContext: sdkContext,
                mapOptions: sdk.MapOptions(),
              ),

              // BlocBuilder<PassengerBloc, PassengerState>(
              //   builder: (context, state) {
              //     if (state is PassengerOrderLoading) {
              //       return Center(
              //         child: Text('Searching for drivers...'),
              //       );
              //     } else if (state is PassengerOrderConfirmed) {
              //       return Center(
              //         child:
              //             Text('Your order has been accepted! Driving coming'),
              //       );
              //     } else if (state is PassengerOrderFailed) {
              //       return Center(
              //         child: Text('Order failed: ${state.message}'),
              //       );
              //     } else {
              //       return Center(
              //         child: Text('Create an order'),
              //       );
              //     }
              //   },
              // ),
            ),
            // Positioned Bottom Panel for Address and Button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16.0),
                height: MediaQuery.of(context).size.height /
                    5, // A quarter of screen height
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.directions, color: Colors.blue),
                        SizedBox(width: 15),
                        Text('Address A: KhanShatyr'),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.directions, color: Colors.green),
                            SizedBox(width: 15),
                            Text('Address B: Mega'),
                          ],
                        ),
                        Text(
                          '15 мин',
                          style: TextStyle(color: Colors.grey[400]),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    BlocBuilder<PassengerBloc, PassengerState>(
                      builder: (context, state) {
                        if (state is PassengerOrderLoading) {
                          // Show "Отменить заказ" when the order is loading
                          return CustomButton(
                            text: 'Отменить заказ',
                            onTap: () {
                              BlocProvider.of<PassengerBloc>(context).add(
                                PassengerCancelOrder(),
                              );
                            },
                          );
                        } else {
                          // Show "Заказать" when no order is in progress
                          return CustomButton(
                            text: 'Заказать',
                            onTap: () {
                              BlocProvider.of<PassengerBloc>(context).add(
                                CreatePassengerOrder(
                                  dropoffLocation: [], // Add correct coordinates
                                  pickupLocation: [], // Add correct coordinates
                                  fare: 25.50,
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
