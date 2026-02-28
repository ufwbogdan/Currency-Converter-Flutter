import 'package:flutter/material.dart';
import 'package:lab_2_new/data/notifiers.dart';

// this is where the result of the conversion is posted
class ResultTextWidget extends StatelessWidget {
  final double? result;

  const ResultTextWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.0,
      child: ValueListenableBuilder(
        valueListenable: currencyNotifier.toCurrency,
        builder: (context, toCurrency, _) {
          // this checks if the result ends in '.00', since there is a
          // computation between doubles, it deletes the pointless ending
          String formatted = result != null
              ? result!.toStringAsFixed(2)
              : '0.00';
          if (formatted.endsWith('.00')) {
            formatted = formatted.substring(0, formatted.length - 3);
          }
          return Text(
            '$formatted $toCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          );
        },
      ),
    );
  }
}
