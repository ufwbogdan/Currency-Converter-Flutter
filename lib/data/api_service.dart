import 'dart:convert';
import 'package:http/http.dart' as http;

// this is where the request is being built using the base url and the api key for fixer
class ApiService {
  static const String _apiKey = String.fromEnvironment('EXCHANGE_API_KEY');
  static const String _baseUrl =
      'https://v6.exchangerate-api.com/v6/$_apiKey/latest/EUR';

  static Future<Map<String, double>?> getExchangeRates() async {
    try {
      final url = Uri.parse(_baseUrl);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['result'] != 'success') {
          //print('API Error: ${data['error-type']}');
          return null;
        }

        final rates = Map<String, dynamic>.from(data['conversion_rates']);
        return rates.map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        );
      } else {
        //print('HTTP Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      //print('Exception fetching rates: $e');
      return null;
    }
  }
}
