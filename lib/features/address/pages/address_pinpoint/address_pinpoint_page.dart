import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:storefront_app/core/core.dart';

import '../../index.dart';

part 'parts/confirm_address.dart';
part 'parts/keys.dart';
part 'parts/marker.dart';
part 'parts/pan_to_current_location_icon.dart';

class AddressPinpointPage extends StatefulWidget {
  final LatLng cameraTarget;
  const AddressPinpointPage({Key? key, required this.cameraTarget})
      : super(key: key);

  @override
  State<AddressPinpointPage> createState() => _AddressPinpointPageState();
}

class _AddressPinpointPageState extends State<AddressPinpointPage> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return DropezyScaffold.textTitle(
      title: res.strings.viewMap,
      child: Stack(
        children: [
          GoogleMap(
            key: AddressPinPointPageKeys.googleMapView,
            initialCameraPosition:
                CameraPosition(target: widget.cameraTarget, zoom: 17),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          ),
          const DropezyMarker(
            key: AddressPinPointPageKeys.marker,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PanToCurrentLocationIcon(
                key: AddressPinPointPageKeys.panToCurrentLocationIcon,
                onPressed: () => getCurrentLocation(mapController),
              ),
              const ConfirmAddress(
                key: AddressPinPointPageKeys.confirmAddress,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

@visibleForTesting
Future getCurrentLocation(
  GoogleMapController mapController,
) async {
  final Position currentLocation = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  mapController.animateCamera(
    CameraUpdate.newCameraPosition(
      CameraPosition(
        zoom: 17,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
      ),
    ),
  );
}
