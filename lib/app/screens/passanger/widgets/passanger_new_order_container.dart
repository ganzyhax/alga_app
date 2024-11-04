import 'dart:developer';

import 'package:alga_app/app/screens/dgis_map/bloc/map_bloc.dart';
import 'package:alga_app/app/screens/dgis_map/bloc/map_event.dart';
import 'package:alga_app/app/screens/dgis_map/components/pick_on_map_screen.dart';
import 'package:alga_app/app/screens/passanger/bloc/passanger_bloc.dart';
import 'package:alga_app/app/screens/passanger/widgets/modal/passanger_fare_modal.dart';
import 'package:alga_app/app/widgets/buttons/custom_button.dart';
import 'package:alga_app/app/widgets/textfield/custom_textfield.dart';
import 'package:alga_app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class PassangerNewOrderContainer extends StatefulWidget {
  final bool isSearchingOrder;
  final addressA;
  final addressB;
  final routeDuration;
  const PassangerNewOrderContainer(
      {super.key,
      required this.isSearchingOrder,
      required this.addressA,
      required this.addressB,
      required this.routeDuration});

  @override
  State<PassangerNewOrderContainer> createState() =>
      _PassangerNewOrderContainerState();
}

class _PassangerNewOrderContainerState
    extends State<PassangerNewOrderContainer> {
  @override
  Widget build(BuildContext context) {
    int totalMinutes = 0;
    try {
      totalMinutes = (widget.routeDuration.inMinutes + 1);
    } catch (e) {}

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: BlocBuilder<PassengerBloc, PassengerState>(
        builder: (context, state) {
          if (state is PassengerLoaded) {
            return Container(
              padding: EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height /
                  2.5, // A quarter of screen height
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      var address = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PickOnMapScreen()),
                      );
                      if (address != null) {
                        GetIt.instance<DGisMapBloc>()
                          ..add(DGisMapChangeRoute(
                              aPoint: address['location'],
                              bPoint: state.addressB['location']));

                        GetIt.instance<PassengerBloc>()
                          ..add(PassangerChangeAAddressDetails(
                              aAddress: address));
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.place_outlined, color: Colors.black),
                        SizedBox(width: 15),
                        Text(state.addressA['address'].toString()),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () async {
                      var address = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PickOnMapScreen()),
                      );
                      if (address != null) {
                        GetIt.instance<DGisMapBloc>()
                          ..add(DGisMapChangeRoute(
                              aPoint: state.addressA['location'],
                              bPoint: address['location']));
                        GetIt.instance<PassengerBloc>()
                          ..add(PassangerChangeBAddressDetails(
                              bAddress: address));
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.gps_fixed_rounded, color: Colors.black),
                            SizedBox(width: 15),
                            Text(state.addressB['address'].toString()),
                          ],
                        ),
                        Text(
                          (state.currentOrderDuration == null)
                              ? ''
                              : '~' +
                                  (state.currentOrderDuration.inMinutes + 1)
                                      .toString() +
                                  ' мин',
                          style: TextStyle(color: Colors.grey[400]),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider(
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          GetIt.instance<PassengerBloc>()
                            ..add(PassangerChangeOrderType(orderType: 0));
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: (state.orderType == 0)
                                  ? AppColors.secondary
                                  : Colors.white),
                          child: Column(
                            children: [
                              Container(
                                width: 70,
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/grey_car_icon.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Эконом',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          GetIt.instance<PassengerBloc>()
                            ..add(PassangerChangeOrderType(orderType: 1));
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: (state.orderType == 1)
                                  ? AppColors.secondary
                                  : Colors.white),
                          child: Column(
                            children: [
                              Container(
                                width: 70,
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/black_car_icon.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Комфорт',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                            onTap: () async {
                              var res = await showModalBottomSheet(
                                context: context,
                                builder: (contexts) {
                                  return PassangerFareModal(
                                    selectedPayMethod: state.payType,
                                    fareValue: state.fare,
                                  );
                                },
                              );
                              GetIt.instance<PassengerBloc>()
                                ..add(PassangerChangeFare(
                                    fareValue: res['fare']));

                              GetIt.instance<PassengerBloc>()
                                ..add(PassangerChangePaymentType(
                                    paymentType: res['payMethod']));
                            },
                            child: Container(
                              padding: EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: AppColors.secondary, width: 2)),
                              child: Row(
                                children: [
                                  Icon(Icons.monetization_on_outlined),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    (state.fare == '')
                                        ? 'Предложите цену'
                                        : state.fare,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          var res = await showModalBottomSheet(
                            context: context,
                            builder: (contexts) {
                              return PassangerFareModal(
                                selectedPayMethod: state.payType,
                                fareValue: state.fare,
                              );
                            },
                          );

                          GetIt.instance<PassengerBloc>()
                            ..add(PassangerChangeFare(fareValue: res['fare']));

                          GetIt.instance<PassengerBloc>()
                            ..add(PassangerChangePaymentType(
                                paymentType: res['payMethod']));
                        },
                        child: Image.asset(
                          (state.payType == 0)
                              ? 'assets/images/kaspi.png'
                              : 'assets/images/nalichka.png',
                          width: 50,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  (widget.isSearchingOrder)
                      ? CustomButton(
                          text: 'Отменить заказ',
                          onTap: () {
                            GetIt.instance<PassengerBloc>().add(
                              PassengerCancelOrder(),
                            );
                          },
                        )
                      : CustomButton(
                          text: 'Заказать',
                          onTap: () {
                            log('create');
                            GetIt.instance<PassengerBloc>()
                              ..add(
                                PassangerCreateOrder(),
                              );
                          },
                        )
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
