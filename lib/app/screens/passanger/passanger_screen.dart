import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alga_app/app/screens/dgis_map/dgis_map.dart';
import 'package:alga_app/app/screens/passanger/widgets/passanger_accepted_order_container.dart';
import 'package:alga_app/app/screens/passanger/widgets/passanger_arrived_order_container.dart';
import 'package:alga_app/app/screens/passanger/widgets/passanger_new_order_container.dart';
import 'package:alga_app/app/screens/passanger/bloc/passanger_bloc.dart';

class PassangerScreen extends StatelessWidget {
  const PassangerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PassengerBloc, PassengerState>(
        builder: (context, state) {
          if (state is PassengerLoaded) {
            return Stack(
              children: [
                // Map Container
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Placeholder color for the map
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: const DGisMapScreen(),
                ),

                // Order Container
                (state.currentOrderData != null &&
                        state.currentOrderData['order']['status'] != 'pending')
                    ? (state.currentOrderData['order']['status'] == 'accepted')
                        ? const PassangerAcceptedOrderContainer()
                        : (state.currentOrderData['order']['status'] ==
                                'arrived')
                            ? const PassangerArrivedOrderContainer()
                            : Container()
                    : PassangerNewOrderContainer(
                        isSearchingOrder: state.isSearchingOrder,
                      ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
