import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as maps_toolkit;
import 'package:storefront_app/core/core.dart';

part 'dropezy_latlng.g.dart';

@HiveType(typeId: HiveTypeIds.dropezyLatLng)
class DropezyLatLng {
  const DropezyLatLng(this.latitude, this.longitude);

  factory DropezyLatLng.fromMap(final Map map) {
    return DropezyLatLng(map['latitude'], map['longitude']);
  }
  @HiveField(DropezyLatLngHiveFieldIds.latitude)
  final double latitude;
  @HiveField(DropezyLatLngHiveFieldIds.longitude)
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
