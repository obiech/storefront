import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletons/skeletons.dart';

import '../../../../core/core.dart';
import '../../../address/blocs/delivery_address/delivery_address_cubit.dart';
import '../address_selection_bottom_sheet/address_selection_bottom_sheet.dart';

part 'parts/address_selection.dart';
part 'parts/keys.dart';
part 'parts/login_or_register.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          SvgPicture.asset(
            context.res.paths.imageDropezyLogo,
            key: const ValueKey(HomeAppBarKeys.dropezyLogo),
            height: 32,
            width: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: AddressSelection(
                    onTap: () {
                      showDropezyBottomSheet(context, (_) {
                        return BlocProvider.value(
                          value: BlocProvider.of<DeliveryAddressCubit>(
                            context,
                          ),
                          child: const AddressSelectionBottomSheet(),
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // TODO (leovinsen): use value from geofence service
                DropezyChip.deliveryDuration(
                  res: context.res,
                  minutes: 15,
                ),
              ],
            ),
          ),
        ],
      ),
      // TODO: Re-enable once notifications feature is available
      // actions: [
      //   IconButton(
      //     key: const ValueKey(HomeAppBarKeys.buttonNotifications),
      //     icon: Icon(
      //       DropezyIcons.bell,
      //       color: context.res.colors.white,
      //       size: 24,
      //     ),
      //     onPressed: () {
      //       // TODO: Implement notifications feature
      //     },
      //   ),
      // ],
    );
  }

  /// Use default toolbar height
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
