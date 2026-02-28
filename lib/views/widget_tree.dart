import 'package:flutter/material.dart';
import 'package:lab_2_new/data/api_service.dart';
import 'package:lab_2_new/data/notifiers.dart';
import 'package:lab_2_new/views/widgets/navbar_widget.dart';
import 'pages/exchange_rates_page.dart';
import 'pages/home_page.dart';

final List<Widget> pages = [const HomePage(), const ExchangeRatesPage()];

// this is the widgetTree, basically it manages the whole app, it chooses which page is shown
class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  void initState() {
    super.initState();
    _fetchExchangeRates();
  }

  Future<void> _fetchExchangeRates() async {
    final fetchedRates = await ApiService.getExchangeRates();
    if (fetchedRates != null && fetchedRates.isNotEmpty) {
      exchangeRatesNotifier.value = fetchedRates;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return Scaffold(
          // resizeToAvoidBottomInset: false,
          appBar: MediaQuery.of(context).orientation == Orientation.landscape
              ? null
              : AppBar(
                  title: Text(
                    selectedPage == 0 ? 'Currency Converter' : 'Exchange Rates',
                  ),
                  backgroundColor: Colors.teal,
                  centerTitle: true,
                ),
          body: IndexedStack(index: selectedPage, children: pages),
          bottomNavigationBar: const NavbarWidget(),
        );
      },
    );
  }
}
