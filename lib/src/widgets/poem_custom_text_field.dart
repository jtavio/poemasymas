import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PoemCustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType textInputType;
  final TextInputFormatter? textInputFormatter;

  const PoemCustomTextField(
      {super.key,
      required this.label,
      required this.controller,
      required this.textInputType,
      this.textInputFormatter});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Raleway',
        fontSize: 17,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 13,
          fontFamily: 'Raleway',
        ),
      ),
      // ignore: unnecessary_null_comparison
      inputFormatters: textInputFormatter != null
          ? <TextInputFormatter>[textInputFormatter!]
          : null,
    );
  }
}
