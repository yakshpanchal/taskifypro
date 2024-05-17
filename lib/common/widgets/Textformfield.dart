import 'package:flutter/material.dart';

class CustomTextFormFiled extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final FormFieldValidator<String> validator; // Validator function
  final bool enabled; // Added enabled parameter
  final TextInputType keyboardType; // Added keyboardType parameter
  final bool obscureText; // Added obscureText parameter
  final ValueChanged<String> onChanged; // Added onChanged parameter
  final int maxline;

  const CustomTextFormFiled(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.prefixIcon,
      required this.validator,
      required this.enabled,
      required this.keyboardType,
      required this.obscureText,
      required this.onChanged,
      required this.maxline});

  @override
  State<CustomTextFormFiled> createState() => _CustomTextFormFiledState();
}

class _CustomTextFormFiledState extends State<CustomTextFormFiled> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled, // Set the enabled property
      keyboardType: widget.keyboardType, // Set keyboardType
      obscureText: widget.obscureText, // Set obscureText
      onChanged: widget.onChanged, // Set onChanged callback
      maxLines: widget.maxline, // set maximum line in textfiled
      decoration: InputDecoration(
        prefixIcon: Icon(widget.prefixIcon),
        // hintText: "Email Address",
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(5.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: Colors.transparent,
        labelText: widget.labelText,

        // labelStyle: TextStyle(color: Colors.red),
      ),
      validator: widget.validator,
    );
  }
}
