import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletons/skeletons.dart';
import 'package:storefront_app/features/auth/widgets/auth_bottom_sheet.dart';

import '../../../../core/core.dart';
import '../../../address/blocs/delivery_address/delivery_address_cubit.dart';
import '../../../auth/domain/repository/user_credentials.dart';
import '../address_selection_bottom_sheet/address_selection_bottom_sheet.dart';

part 'parts/address_selection.dart';
part 'parts/keys.dart';
part 'parts/login_or_register.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    Key? key,
    required this.userCredentialsStream,
  }) : super(key: key);

  final Stream<UserCredentials?> userCredentialsStream;

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
            child: StreamBuilder<UserCredentials?>(
              stream: userCredentialsStream,
              builder: (context, snapshot) {
                final creds = snapshot.data;
                if (creds == null) {
                  return PromptLoginOrRegister(
                    onTap: () {
                      showDropezyBottomSheet(context, (_) {
                        return const AuthBottomSheet();
                      });
                    },
                  );
                }
                return Row(
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
                          //TODO (leovinsen): Implement Address Selection
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
                );
              },
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          key: const ValueKey(HomeAppBarKeys.buttonNotifications),
          icon: Icon(
            DropezyIcons.bell,
            color: context.res.colors.white,
            size: 24,
          ),
          onPressed: () {
            // TODO: Implement notifications feature
          },
        ),
      ],
    );
  }

  /// Use default toolbar height
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
