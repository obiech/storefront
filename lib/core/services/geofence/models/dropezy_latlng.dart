import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as maps_toolkit;

class DropezyLatLng {
  const DropezyLatLng(this.latitude, this.longitude);

  factory DropezyLatLng.fromMap(final Map map) {
    return DropezyLatLng(map['latitude'], map['longitude']);
  }

  final double latitude;
  final double longitude;

  /// To convert [DropezyLatLng] to [LatLng] model
  ///  from [google_maps_flutter] package.
  LatLng get latLangGoogleMap => LatLng(latitude, longitude);

  /// To convert [DropezyLatLng] to [LatLng] model from [maps_toolkit] package.
  maps_toolkit.LatLng get latLngMapsToolKit =>
      maps_toolkit.LatLng(latitude, longitude);

  Map<String, dynamic> toMap() =>
      {'latitude': latitude, 'longitude': longitude};
}
