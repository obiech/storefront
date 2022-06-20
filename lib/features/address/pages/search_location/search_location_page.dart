import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/injection.dart';
import 'package:storefront_app/features/address/index.dart';
import 'package:storefront_app/features/permission_handler/index.dart';

part 'keys.dart';
part 'wrapper.dart';

class SearchLocationPage extends StatelessWidget {
  const SearchLocationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: context.res.strings.whereIsYourAddress,
      child: MultiBlocListener(
        listeners: [
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SearchLocationHeader(),
            ThickDivider(),
            Expanded(
              child: SearchLocationResult(),
            ),
          ],
        ),
      ),
    );
  }

  void _onPermissionPermanentlyDenied(BuildContext context) {
    showDropezyBottomSheet(context, (_) {
      return const RequestLocationBottomSheet();
    });
  }

  void _onPermissionDenied(BuildContext context) {
    showDropezyBottomSheet(context, (_) {
      return const RequestLocationBottomSheet();
    });
  }

  void _onPermissionGranted(BuildContext context) {
    context.read<SearchLocationBloc>().add(const UseCurrentLocation());
  }
}
