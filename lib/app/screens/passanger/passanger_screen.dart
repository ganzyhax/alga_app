import 'package:alga_app/app/screens/dgis_map/bloc/map_bloc.dart';
import 'package:alga_app/app/screens/dgis_map/bloc/map_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alga_app/app/screens/dgis_map/dgis_map.dart';
import 'package:alga_app/app/screens/passanger/widgets/passanger_accepted_order_container.dart';
import 'package:alga_app/app/screens/passanger/widgets/passanger_arrived_order_container.dart';
import 'package:alga_app/app/screens/passanger/widgets/passanger_new_order_container.dart';
import 'package:alga_app/app/screens/passanger/bloc/passanger_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';

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
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Placeholder color for the map
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: BlocProvider(
                    create: (context) => GetIt.instance<DGisMapBloc>()
                      ..add(
                        DGisMapLoad(
                          aPoint: [
                            state.addressA['location'][0],
                            state.addressA['location'][1],
                          ],
                          bPoint: [
                            state.addressB['location'][0],
                            state.addressB['location'][1]
                          ],
                        ),
                      ),
                    child: DGisMapScreen(),
                  ),
                ),

                Positioned(
                    top: 35,
                    left: 15,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Center(
                              child: Icon(
                            Icons.arrow_back_ios,
                            size: 22,
                          )),
                        ),
                      ),
                    )),

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
                        addressA: state.addressA,
                        addressB: state.addressB,
                        routeDuration: state.currentOrderDuration,
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
