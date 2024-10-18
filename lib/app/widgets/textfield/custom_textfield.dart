import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade300, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5), // Shadow position
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Enter your text here',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 16,
          ),
          border: InputBorder.none, // Removes the default border
          focusedBorder: InputBorder.none, // No border when focused
          enabledBorder: InputBorder.none, // No border when enabled
          contentPadding: EdgeInsets.symmetric(
              horizontal: 20, vertical: 15), // Padding inside the text field
        ),
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        cursorColor: Colors.white, // Cursor color
      ),
    );
  }
}
