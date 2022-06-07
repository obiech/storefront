import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';
import 'package:storefront_app/features/permission_handler/index.dart';

class AddressEmptyView extends StatelessWidget {
  const AddressEmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(context.res.strings.addressEmpty),
        const SizedBox(height: 16),
        DropezyButton.secondary(
          key: ChangeAddressPageKeys.addAddressButton,
          label: context.res.strings.addAddress,
          leftIcon: Icon(
            DropezyIcons.plus,
            color: context.res.colors.blue,
          ),
          onPressed: () {
            context
                .read<PermissionHandlerCubit>()
                .requestPermission(Permission.location);
          },
        )
      ],
    );
  }
}
