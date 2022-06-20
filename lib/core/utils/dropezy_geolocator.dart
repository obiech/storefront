import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class DropezyGeolocator {
  const DropezyGeolocator();

  /// Return device position
  /// i.e. latitude & longitude
  Future<Position> getCurrentPosition() async {
    return Geolocator.getCurrentPosition();
  }
}
