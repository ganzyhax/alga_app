import 'package:alga_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData? iconData;
  final IconData? focusedIconData; // New property for focused icon
  final TextEditingController controller;
  final Color? bgColor;
  final FocusNode? focusNode; // Make this required
  final Color? iconColor;
  final Color? focusedIconColor; // New property for focused icon color

  CustomTextField({
    required this.controller,
    required this.hintText,
    this.iconData,
    this.focusedIconData, // Accept focused icon
    this.iconColor,
    required this.focusNode, // Required
    this.bgColor,
    this.focusedIconColor, // Accept focused icon color
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late IconData _currentIcon;
  late Color _currentIconColor;

  @override
  void initState() {
    super.initState();
    _currentIcon = widget.iconData ?? Icons.text_fields; // Default icon
    _currentIconColor = widget.iconColor ?? Colors.black; // Default icon color
    widget.focusNode?.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      // Change icon and color based on focus state
      if (widget.focusNode!.hasFocus) {
        _currentIcon =
            widget.focusedIconData ?? widget.iconData ?? Icons.text_fields;
        _currentIconColor =
            widget.focusedIconColor ?? widget.iconColor ?? Colors.black;
      } else {
        _currentIcon = widget.iconData ?? Icons.text_fields;
        _currentIconColor = widget.iconColor ?? Colors.black;
      }
    });
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_onFocusChange); // Clean up listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.secondary, width: 2),
        borderRadius: BorderRadius.circular(15),
        color: widget.bgColor,
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode, // Assign the passed focus node
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          prefixIcon: Icon(
            _currentIcon,
            color: _currentIconColor, // Use current icon color
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 12,
          ),
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
        cursorColor: Colors.black,
      ),
    );
  }
}
