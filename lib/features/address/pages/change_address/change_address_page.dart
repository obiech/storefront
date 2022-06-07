import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';
import 'package:storefront_app/features/permission_handler/index.dart';

part 'keys.dart';

class ChangeAddressPage extends StatelessWidget {
  const ChangeAddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: context.res.strings.changeAddress,
      child: MultiBlocListener(
        listeners: [
          /// Handle when address updated
          BlocListener<DeliveryAddressCubit, DeliveryAddressState>(
            listenWhen: (previous, current) => previous != current,
            listener: (context, state) =>
                _onDeliveryAddressUpdated(state, context),
          ),

          /// Handle when requested permission is granted
          BlocListener<PermissionHandlerCubit, PermissionHandlerState>(
            listenWhen: (previous, current) => current is PermissionGranted,
            listener: (context, state) => _onPermissionGranted(context),
          ),

          /// Handle when requested permission is denied
          BlocListener<PermissionHandlerCubit, PermissionHandlerState>(
            listenWhen: (previous, current) => current is PermissionDenied,
            listener: (context, state) => _onPermissionDenied(context),
          ),

          /// Handle when requested permission is permanently denied
          BlocListener<PermissionHandlerCubit, PermissionHandlerState>(
            listenWhen: (previous, current) =>
                current is PermissionPermanentlyDenied,
            listener: (context, state) =>
                _onPermissionPermanentlyDenied(context),
          ),
        ],
        child: BlocBuilder<DeliveryAddressCubit, DeliveryAddressState>(
          builder: (context, state) {
            if (state is DeliveryAddressLoaded) {
              return Padding(
                padding: EdgeInsets.all(context.res.dimens.pagePadding),
                child: Column(
                  children: [
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final address = state.addressList[index];
                          return AddressCard(
                            address: address,
                            isActive: address == state.activeAddress,
                            onPressed: () {
                              if (address != state.activeAddress) {
                                context
                                    .read<DeliveryAddressCubit>()
                                    .setActiveAddress(address);
                              }
                            },
                          );
                        },
                        itemCount: state.addressList.length,
                      ),
                    ),
                    DropezyButton.secondary(
                      key: ChangeAddressPageKeys.addAddressButton,
                      label: context.res.strings.addAddress,
                      leftIcon: const Icon(
                        DropezyIcons.plus,
                        color: DropezyColors.blue,
                      ),
                      onPressed: () {
                        context
                            .read<PermissionHandlerCubit>()
                            .requestPermission(Permission.location);
                      },
                    ),
                  ],
                ),
              );
            } else if (state is DeliveryAddressLoadedEmpty) {
              return const AddressEmptyView();
            } else if (state is DeliveryAddressError) {
              return Text(state.message);
            } else {
              return const AddressLoadingView();
            }
          },
        ),
      ),
    );
  }

  void _onPermissionPermanentlyDenied(BuildContext context) {
    context.pushRoute(const RequestLocationAccessRoute());
  }

  void _onPermissionDenied(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      DropezySnackBar.info(
        context.res.strings.locationAccessRationale,
      ),
    );
  }

  void _onPermissionGranted(BuildContext context) {
    // TODO (widy): Change of flow - navigate to Add Address/Search Address when SearchLocationPage ready
    context.pushRoute(const AddressDetailRoute());
  }

  void _onDeliveryAddressUpdated(
    DeliveryAddressState state,
    BuildContext context,
  ) {
    if (state is DeliveryAddressLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        DropezySnackBar.info(
          context.res.strings
              .updatedAddressSnackBarContent(state.activeAddress.title),
        ),
      );
    }
  }
}
