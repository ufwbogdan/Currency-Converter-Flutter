import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// this is basically the amount field where the users puts any number to convert
class AmountTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final double? width;

  const AmountTextFieldWidget({
    super.key,
    required this.controller,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          // added some limitations to the user
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          LengthLimitingTextInputFormatter(20),
        ],
        decoration: const InputDecoration(
          labelText: 'Enter the amount...',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
