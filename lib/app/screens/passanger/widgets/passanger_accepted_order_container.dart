import 'package:alga_app/app/screens/passanger/bloc/passanger_bloc.dart';
import 'package:alga_app/app/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class PassangerAcceptedOrderContainer extends StatelessWidget {
  const PassangerAcceptedOrderContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(16.0),
        height: MediaQuery.of(context).size.height /
            5, // A quarter of screen height
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
            CustomButton(
              text: 'Отменить заказ',
              onTap: () {
                GetIt.instance<PassengerBloc>().add(
                  PassengerCancelOrder(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
