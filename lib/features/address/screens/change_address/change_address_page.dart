import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';

class ChangeAddressPage extends StatelessWidget {
  const ChangeAddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: context.res.strings.changeAddress,
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
                        return AddressCard(address: address);
                      },
                      itemCount: state.addressList.length,
                    ),
                  ),
                  DropezyButton.secondary(
                    label: context.res.strings.addAddress,
                    leftIcon: const Icon(
                      DropezyIcons.plus,
                      color: DropezyColors.blue,
                    ),
                    // TODO (widy): Navigate to Add Address Page
                    onPressed: () {},
                  ),
                ],
              ),
            );
          } else if (state is DeliveryAddressError) {
            return Text(state.message);
          } else {
            return const AddressLoadingView();
          }
        },
      ),
    );
  }
}
