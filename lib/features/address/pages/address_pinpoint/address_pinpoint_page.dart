import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:storefront_app/core/core.dart';

class AddressPinpointPage extends StatelessWidget {
  const AddressPinpointPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: 'Lihat Peta',
      child: const GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0.0, 0.0),
        ),
      ),
    );
  }
}
