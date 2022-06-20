import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/core.dart';
import '../../../di/injection.dart';
import '../blocs/language_selection/language_selection_cubit.dart';
import 'language_selection/language_selection_bottomsheet.dart';
import 'widgets.dart';

class ProfileAccountSection extends StatelessWidget {
  const ProfileAccountSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.res.strings.account(),
            style: context.res.styles.title,
          ),
          const SizedBox(height: 8.0),
          ProfileMenuTile.icon(
            icon: DropezyIcons.document,
            title: context.res.strings.myOrders,
            onTap: () {
              context.pushRoute(
                const OrderRouter(
                  children: [OrderHistoryRoute()],
                ),
              );
            },
          ),
          ProfileMenuTile.icon(
            icon: DropezyIcons.pin_outlined,
            title: context.res.strings.changeAddress,
            onTap: () {
              context.pushRoute(
                const ChangeAddressRoute(),
              );
            },
          ),
          ProfileMenuTile.icon(
            icon: DropezyIcons.language,
            title: context.res.strings.selectLanguage,
            onTap: () {
              showDropezyBottomSheet(
                context,
                (_) => BlocProvider.value(
                  value: getIt<LanguageSelectionCubit>(),
                  child: LanguageSelectionBottomSheet(
                    mainContext: context,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
