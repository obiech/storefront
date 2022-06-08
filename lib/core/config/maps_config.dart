import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:storefront_app/core/utils/dotenv.ext.dart';

/// Contains access configuration for Google Maps API
///
class MapsConfig {
  static String get mapsApiKey =>
      dotenv.getString('MAPS_API_KEY', fallback: '');
}
