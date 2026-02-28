import 'package:flutter/material.dart';
import 'package:lab_2_new/data/constants.dart';
import 'package:lab_2_new/data/notifiers.dart';
import 'package:lab_2_new/views/widgets/autocomplete_widget.dart';

// this is where the list of exchange rates is displayed
class ExchangeRatesPage extends StatefulWidget {
  const ExchangeRatesPage({super.key});

  @override
  State<ExchangeRatesPage> createState() => _ExchangeRatesPageContentState();
}

class _ExchangeRatesPageContentState extends State<ExchangeRatesPage> {
  // this holds the value of the selected base currency for the list
  final ValueNotifier<String?> selectedCurrencyNotifier =
      ValueNotifier<String?>('EUR');

  @override
  void dispose() {
    selectedCurrencyNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ValueListenableBuilder<Map<String, double>>(
        valueListenable: exchangeRatesNotifier,
        builder: (context, rates, child) {
          final displayRates = rates.isNotEmpty ? rates : exchangeRates;

          if (displayRates.isEmpty) {
            return const Center(child: Text('No exchange rates available'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Base Currency: "),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 120.0,
                      child: CountryCurrencyAutocomplete(
                        targetCurrencyNotifier: selectedCurrencyNotifier,
                        currencies: displayRates.keys.toSet(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<String?>(
                  valueListenable: selectedCurrencyNotifier,
                  builder: (context, selectedCurrency, _) {
                    final baseCurrency = selectedCurrency ?? 'EUR';

                    // the point of this is to exclude the selected base currency from the list
                    final filteredCurrencies = displayRates.entries
                        .where((e) => e.key != baseCurrency)
                        .toList();

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      itemCount: filteredCurrencies.length,
                      separatorBuilder: (_, _) => const Divider(),
                      itemBuilder: (context, index) {
                        final currency = filteredCurrencies[index];

                        final double amount = convertCurrency(
                          amount: 1,
                          from: baseCurrency,
                          to: currency.key,
                        );

                        String displayAmount;

                        if (amount < 0.01) {
                          displayAmount = amount.toStringAsFixed(
                            5,
                          ); // e.g., "0.00069"
                        } else {
                          displayAmount = amount.toStringAsFixed(
                            2,
                          ); // e.g., "1.08"
                          // Optional: Keep your old cleanup logic for standard numbers only
                          if (displayAmount.endsWith('.00')) {
                            displayAmount = displayAmount.substring(
                              0,
                              displayAmount.length - 3,
                            );
                          }
                        }

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),

                          title: Text(
                            currency.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          subtitle: Text(
                            '1 $baseCurrency ≈ $displayAmount ${currency.key}',
                            style: TextStyle(color: Colors.grey[400]),
                          ),

                          trailing: const Icon(
                            Icons.currency_exchange,
                            size: 20,
                            color: Colors.teal,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
