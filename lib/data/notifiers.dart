import 'package:flutter/material.dart';

// here is where all the notifiers are being held
ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);
ValueNotifier<Map<String, double>> exchangeRatesNotifier = ValueNotifier({});

// the currency class, having two values: the currency the user wants to convert from,
// and the currency that the user wants to convert to, holding both the actual currency
// and the rate
class CurrencyNotifier {
  final ValueNotifier<String?> fromCurrency = ValueNotifier(null);
  final ValueNotifier<String?> toCurrency = ValueNotifier(null);

  void swap() {
    if (fromCurrency.value == null || toCurrency.value == null) return;
    final temp = fromCurrency.value;
    fromCurrency.value = toCurrency.value;
    toCurrency.value = temp;
  }

  // the if statements in both functions is to avoid having a same currency conversion
  void setFrom(String currency) {
    if (currency == toCurrency.value) swap();
    fromCurrency.value = currency;
  }

  void setTo(String currency) {
    if (currency == fromCurrency.value) swap();
    toCurrency.value = currency;
  }
}

final currencyNotifier = CurrencyNotifier();
