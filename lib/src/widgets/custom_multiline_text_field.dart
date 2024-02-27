import 'package:flutter/material.dart';

class CustomMultiLineTextField extends StatelessWidget {
  final String label, placeholder;
  final TextEditingController controller;
  final VoidCallback function;

  const CustomMultiLineTextField(
      {Key? key, required this.label, required this.placeholder, required this.controller, required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 5,
      style: const TextStyle(color: Colors.white, fontFamily: 'Raleway', fontSize: 17),
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: function,
          icon: const Icon(Icons.remove_red_eye),
        ),
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13, fontFamily: 'Raleway'),
        alignLabelWithHint: true,
        hintText: placeholder,
      ),
    );
  }
}
