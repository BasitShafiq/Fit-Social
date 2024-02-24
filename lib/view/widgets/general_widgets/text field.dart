import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    Key? key,
    required this.label,
    this.obscureText = false,
    required this.controller,
    required this.keyboardType,
  }) : super(key: key);
  String label;
  bool obscureText;
  TextEditingController controller;
  TextInputType keyboardType;
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      controller: controller,
      obscuringCharacter: '•',
      obscureText: obscureText,
      style: const TextStyle(color: Color.fromARGB(255, 255, 251, 251)),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        filled: false,
        alignLabelWithHint: true,
        labelText: label,
        hintText: label,
      ),
    );
  }
}
