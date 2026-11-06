import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.isObscured = false,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.autofillHints,
    this.maxLines = 1,
    this.maxLength,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String? value)? validator;
  final bool isObscured;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;
  final int maxLines;
  final int? maxLength;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: isObscured,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      maxLines: isObscured ? 1 : maxLines,
      maxLength: maxLength,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
    );
  }
}
