import 'package:flutter/material.dart';

class CustomElevetedButton extends StatefulWidget {
  final String buttonText;
  final Color backgroundColor;
  final Color textColor;
  final double elevation;
  final double borderRadius;
  final VoidCallback onPressed;
  final double buttonWidth;
  final double buttonHeight;
  final double buttontextSize;

  const CustomElevetedButton(
      {super.key,
      required this.buttonText,
      required this.backgroundColor,
      required this.textColor,
      required this.elevation,
      required this.borderRadius,
      required this.onPressed,
      required this.buttonWidth,
      required this.buttonHeight,
      required this.buttontextSize});

  @override
  State<CustomElevetedButton> createState() => _CustomElevetedButtonState();
}

class _CustomElevetedButtonState extends State<CustomElevetedButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.buttonWidth,
      height: widget.buttonHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: widget.backgroundColor, // Background color
          onPrimary: widget.textColor, // Text color
          elevation: widget.elevation, // Elevation
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(widget.borderRadius), // Rounded corners
          ),
        ),
        onPressed: widget.onPressed,
        child: Text(
          widget.buttonText,
          style: TextStyle(
            fontSize: widget.buttontextSize,
          ),
        ),
      ),
    );
  }
}
