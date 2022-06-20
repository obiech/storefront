import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';

@LazySingleton()
class DropezyGeolocator {
  const DropezyGeolocator();

  /// Return device position
  /// i.e. latitude & longitude
  Future<Position> getCurrentPosition() async {
    return Geolocator.getCurrentPosition();
  }

  /// Check if location services are enabled.
  RepoResult<bool> isLocationServiceEnabled() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      return right(serviceEnabled);
    } else {
      return left(Failure('Location services are disabled.'));
    }
  }
}
