import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final int maxLines;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the $label';
        }
        return null;
      },
    );
  }
}
