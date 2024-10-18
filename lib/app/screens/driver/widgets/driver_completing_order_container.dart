import 'package:alga_app/app/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';

class DriverCompletingOrderContainer extends StatelessWidget {
  const DriverCompletingOrderContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(16.0),
        height: MediaQuery.of(context).size.height / 4,
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
          children: [
            Center(
              child: Text(
                "Вас ждет пассажир",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            CustomButton(text: 'Я пришел'),
          ],
        ),
      ),
    );
  }
}
