import 'package:flutter/material.dart';
import 'package:lab_2_new/data/constants.dart';
import 'package:lab_2_new/data/notifiers.dart';
import 'package:lab_2_new/views/widgets/currency_selector_widget.dart';
import 'package:lab_2_new/views/widgets/amount_text_field_widget.dart';
import 'package:lab_2_new/views/widgets/result_text_widget.dart';
import '../../data/location_service.dart';

// this is the homePage, here is the actual converter situated
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? result;
  final TextEditingController exchangeController = TextEditingController();

  double get screenWidth => MediaQuery.of(context).size.width;
  bool get isLandscape =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  @override
  void initState() {
    super.initState();
    _initCurrencyFromLocation();
    // listeners so the result changes everytime there is a change of currency / amount
    exchangeController.addListener(compute);
    currencyNotifier.fromCurrency.addListener(compute);
    currencyNotifier.toCurrency.addListener(compute);
  }

  @override
  void dispose() {
    exchangeController.removeListener(compute);
    currencyNotifier.fromCurrency.removeListener(compute);
    currencyNotifier.toCurrency.removeListener(compute);
    exchangeController.dispose();
    super.dispose();
  }

  Future<void> _initCurrencyFromLocation() async {
    try {
      final fromValue = await LocationService.getInitialCurrency().timeout(
        const Duration(seconds: 15),
      );
      currencyNotifier.setFrom(fromValue);
      currencyNotifier.setTo(fromValue == 'EUR' ? 'USD' : 'EUR');
    } catch (e) {
      currencyNotifier.setFrom('EUR');
      currencyNotifier.setTo('USD');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currencyNotifier.fromCurrency.value == null) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 8.0));
    }

    // added a gesture detector so that the buttons lose focus when the user taps anywhere else
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: isLandscape ? _buildLandscapeLayout() : _buildPortraitLayout(),
    );
  }

  Widget _buildPortraitLayout() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CurrencySelectorWidget(),
              const SizedBox(height: 12.0),
              AmountTextFieldWidget(
                controller: exchangeController,
                width: screenWidth / 1.5,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
                child: Icon(Icons.arrow_downward_sharp),
              ),
              ResultTextWidget(result: result),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout() {
    return Center(
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CurrencySelectorWidget(),
                const SizedBox(height: 12.0),
                AmountTextFieldWidget(
                  controller: exchangeController,
                  width: screenWidth * 0.2,
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_sharp, size: 32),
            ResultTextWidget(result: result),
          ],
        ),
      ),
    );
  }

  // function that does the converting
  void compute() {
    if (currencyNotifier.fromCurrency.value == null ||
        currencyNotifier.toCurrency.value == null) {
      return;
    }
    final double? amount = double.tryParse(exchangeController.text);
    if (amount != null) {
      setState(() {
        result = convertCurrency(
          amount: amount,
          from: currencyNotifier.fromCurrency.value!,
          to: currencyNotifier.toCurrency.value!,
        );
      });
    } else {
      setState(() {
        result = null;
      });
    }
  }
}
