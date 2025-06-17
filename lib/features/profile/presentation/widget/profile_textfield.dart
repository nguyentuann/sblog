import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final bool allowEmpty;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.allowEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      
      validator: (value) {
        if (!allowEmpty && (value == null || value.trim().isEmpty)) {
          return 'Vui lòng nhập $labelText';
        }
        return null;
      },
    );
  }
}
