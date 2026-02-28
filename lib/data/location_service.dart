import 'package:geocoding/geocoding.dart';
import 'package:lab_2_new/data/constants.dart';
import 'geolocation.dart';

// location class that fetches the country code given the coordinates from geolocator
class LocationService {
  static Future<String> getInitialCurrency() async {
    final countryCode = await getCountryCode();
    return countryCode != null
        ? countryCodeToCurrency[countryCode] ?? 'EUR'
        : 'EUR';
  }

  static Future<String?> getCountryCode() async {
    try {
      final position = await determinePosition();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        return placemarks.first.isoCountryCode;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
