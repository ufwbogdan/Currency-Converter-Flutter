import 'package:flutter/material.dart';
import 'package:lab_2_new/data/constants.dart';
import 'package:lab_2_new/data/notifiers.dart';
import 'package:lab_2_new/views/widgets/autocomplete_widget.dart';

class CurrencySelectorWidget extends StatelessWidget {
  const CurrencySelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String, double>>(
      valueListenable: exchangeRatesNotifier,
      builder: (context, rates, _) {
        final displayRates = rates.isNotEmpty ? rates : exchangeRates;
        final currencies = displayRates.keys.toSet();
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 80.0,
              child: CountryCurrencyAutocomplete(
                targetCurrencyNotifier: currencyNotifier.fromCurrency,
                currencies: currencies,
                onSelected: currencyNotifier.setFrom,
              ),
            ),
            IconButton(
              onPressed: currencyNotifier.swap,
              icon: const Icon(Icons.compare_arrows_sharp),
            ),
            SizedBox(
              width: 80.0,
              child: CountryCurrencyAutocomplete(
                targetCurrencyNotifier: currencyNotifier.toCurrency,
                currencies: currencies,
                onSelected: currencyNotifier.setTo,
              ),
            ),
          ],
        );
      },
    );
  }
}
