import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/injection.dart';
import 'package:storefront_app/features/address/index.dart';

part 'keys.dart';
part 'wrapper.dart';

// TODO (widy): Request for location permission when page loaded
// https://dropezy.atlassian.net/browse/STOR-318
class AddressDetailPage extends StatefulWidget {
  const AddressDetailPage({Key? key}) : super(key: key);

  @override
  State<AddressDetailPage> createState() => _AddressDetailPageState();
}

class _AddressDetailPageState extends State<AddressDetailPage> {
  final _formKey = GlobalKey<FormState>();
  static GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: context.res.strings.addressDetail,
      actions: [
        IconButton(
          // TODO (Widy): Handle delete address
          onPressed: () {},
          icon: const Icon(DropezyIcons.trash),
        ),
      ],
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.res.dimens.pagePadding),
          child: MultiBlocListener(
            listeners: blocListenerHandler,
            child: BlocBuilder<AddressDetailBloc, AddressDetailState>(
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DropezyTextFormField(
                                fieldKey:
                                    AddressDetailPageKeys.addressNameField,
                                label: context.res.strings.addressName,
                                hintText: context.res.strings.addressNameHint,
                                onChanged: (name) {
                                  context
                                      .read<AddressDetailBloc>()
                                      .add(AddressNameChanged(name));
                                },
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                height: 100,
                                child: GoogleMap(
                                  key: AddressDetailPageKeys.googleMapView,
                                  onMapCreated: (controller) {
                                    _mapController = controller;
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.addressDetailsName,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ).withLineHeight(14),
                                        ),
                                        Text(
                                          state.addressDetails,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ).withLineHeight(16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              DropezyTextFormField(
                                fieldKey:
                                    AddressDetailPageKeys.addressDetailField,
                                label: context.res.strings.addressDetail,
                                hintText: context.res.strings.addressDetailHint,
                                onChanged: (addressDetail) {
                                  context.read<AddressDetailBloc>().add(
                                        AddressDetailNoteChanged(addressDetail),
                                      );
                                },
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 24),
                              DropezyTextFormField(
                                fieldKey:
                                    AddressDetailPageKeys.recipientNameField,
                                label: context.res.strings.recipientName,
                                hintText: context.res.strings.recipientNameHint,
                                onChanged: (name) {
                                  context
                                      .read<AddressDetailBloc>()
                                      .add(RecipientNameChanged(name));
                                },
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 24),
                              DropezyTextFormField(
                                fieldKey:
                                    AddressDetailPageKeys.phoneNumberField,
                                label: context.res.strings.phoneNumber,
                                hintText: context.res.strings.phoneNumberHint,
                                onChanged: (phoneNumber) {
                                  context
                                      .read<AddressDetailBloc>()
                                      .add(RecipientPhoneChanged(phoneNumber));
                                },
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 24),
                              CheckboxListTile(
                                key: AddressDetailPageKeys
                                    .primaryAddressCheckbox,
                                value: state.isPrimaryAddress,
                                title:
                                    Text(context.res.strings.usePrimaryAddress),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (newValue) {
                                  context
                                      .read<AddressDetailBloc>()
                                      .add(PrimaryAddressChanged(newValue!));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: DropezyButton.primary(
                          key: AddressDetailPageKeys.saveAddressButton,
                          label: context.res.strings.saveAddress,
                          isLoading: state.loading,
                          onPressed: () {
                            dismissKeyboard(context);

                            if (!_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                DropezySnackBar.info(
                                  context.res.strings.makeSureFieldsFilled,
                                ),
                              );
                              return;
                            }

                            context
                                .read<AddressDetailBloc>()
                                .add(const FormSubmitted());
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  final blocListenerHandler = [
    /// Handle when error occurred
    BlocListener<AddressDetailBloc, AddressDetailState>(
      listenWhen: (previous, current) => current.errorMessage != null,
      listener: (context, state) {
        final errorMessage = state.errorMessage;
        if (errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(DropezySnackBar.info(errorMessage));
        }
      },
    ),

    /// Handle when Address created/updated
    BlocListener<AddressDetailBloc, AddressDetailState>(
      listenWhen: (previous, current) => current.addressUpdated,
      listener: (context, state) async {
        context.read<DeliveryAddressCubit>().fetchDeliveryAddresses();
        context.popRoute();
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            DropezySnackBar.info(
              context.res.strings.savedAddressSnackBarContent,
            ),
          );
      },
    ),

    /// Handle when [LatLng] changes
    BlocListener<AddressDetailBloc, AddressDetailState>(
      listenWhen: (previous, current) => previous.latLng != current.latLng,
      listener: (context, state) async {
        _mapController?.animateCamera(CameraUpdate.newLatLng(state.latLng));
      },
    ),
  ];
}
