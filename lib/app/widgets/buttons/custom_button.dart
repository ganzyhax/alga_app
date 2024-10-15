import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  const CustomButton({super.key, this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.green),
        padding: EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 15),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
      ),
    );
  }
}
