part of '../address_detail_page.dart';

class _AddressGoogleMapView extends StatelessWidget {
  static GoogleMapController? mapController;

  const _AddressGoogleMapView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Handle when [LatLng] changes
    return BlocListener<AddressDetailBloc, AddressDetailState>(
      listenWhen: (previous, current) => previous.latLng != current.latLng,
      listener: (context, state) async {
        mapController?.animateCamera(CameraUpdate.newLatLng(state.latLng));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<AddressDetailBloc, AddressDetailState>(
            buildWhen: (p, c) => p.latLng != c.latLng,
            builder: (context, state) {
              return SizedBox(
                height: 100,
                child: GoogleMap(
                  key: AddressDetailPageKeys.googleMapView,
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: state.latLng,
                    zoom: 16,
                  ),
                  onTap: (latLng) {
                    context.pushRoute(
                      AddressPinpointRoute(
                        cameraTarget: state.latLng,
                      ),
                    );
                  },
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                DropezyIcons.pin_outlined,
                color: context.res.colors.black,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<AddressDetailBloc, AddressDetailState>(
                      buildWhen: (p, c) =>
                          p.addressDetailsName != c.addressDetailsName,
                      builder: (context, state) {
                        return Text(
                          state.addressDetailsName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ).withLineHeight(14),
                        );
                      },
                    ),
                    BlocBuilder<AddressDetailBloc, AddressDetailState>(
                      buildWhen: (p, c) => p.addressDetails != c.addressDetails,
                      builder: (context, state) {
                        return Text(
                          state.addressDetails,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ).withLineHeight(16),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
