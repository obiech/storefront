import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';

/// Cart address selection widget.
///
/// Shows a [DeliveryAddressDetail] that redirects to [ChangeAddressPage]
/// when tapped.
class CartAddressSelection extends StatelessWidget {
  const CartAddressSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryAddressCubit, DeliveryAddressState>(
      builder: (context, state) {
        if (state is DeliveryAddressLoaded) {
          return DeliveryAddressDetail(
            heading: context.res.strings.deliveryDetails,
            enableAddressSelection: true,
            address: state.activeAddress,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
