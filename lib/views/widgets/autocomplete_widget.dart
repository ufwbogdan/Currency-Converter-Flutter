import 'package:flutter/material.dart';
import 'package:lab_2_new/data/constants.dart';

class CountryCurrencyAutocomplete extends StatefulWidget {
  final ValueNotifier<String?> targetCurrencyNotifier;
  final Set<String> currencies;
  final Function(String)? onSelected;

  const CountryCurrencyAutocomplete({
    super.key,
    required this.targetCurrencyNotifier,
    required this.currencies,
    this.onSelected,
  });

  @override
  State<CountryCurrencyAutocomplete> createState() =>
      _CountryCurrencyAutocompleteState();
}

class _CountryCurrencyAutocompleteState
    extends State<CountryCurrencyAutocomplete> {
  @override
  Widget build(BuildContext context) {
    // autocomplete used so that the user can type either the country or the currency
    // and the selectable list changes dinamically
    return Autocomplete<String>(
      // optionBuilder, it runs every time the user types a letter
      optionsBuilder: (TextEditingValue currencyTextEditingValue) {
        final query = currencyTextEditingValue.text.toLowerCase().trim();
        if (query == '') {
          return const Iterable<String>.empty();
        }
        // here it does the search in all countries / currencies
        return countryToCurrency.entries
            .where((entry) {
              // does a check if the input matches
              final matchesQuery =
                  entry.value.toLowerCase().contains(query) ||
                  entry.key.toLowerCase().contains(query);

              // this is a safety check, only goes through if the currency exists
              // in the fetched currencies list from fixer API
              final isAvailable = widget.currencies.contains(entry.value);

              return matchesQuery && isAvailable;
            })
            .map((entry) => entry.value)
            .toSet();
      },

      onSelected: (currency) {
        if (widget.onSelected != null) {
          widget.onSelected!(currency);
        } else {
          // this lets the app know that a currency has been changed
          widget.targetCurrencyNotifier.value = currency;
        }
      },

      // this is so that the box always displays the correct currency,
      // even though the user didn t type it
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        widget.targetCurrencyNotifier.addListener(() {
          final currentCurrency = widget.targetCurrencyNotifier.value;
          if (currentCurrency != null && controller.text != currentCurrency) {
            controller.text = currentCurrency;
          }
        });
        final currentCurrency = widget.targetCurrencyNotifier.value;
        if (currentCurrency != null && controller.text != currentCurrency) {
          controller.text = currentCurrency;
        }
        return TextField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.0,
              vertical: 8.0,
            ),
          ),
        );
      },
    );
  }
}
