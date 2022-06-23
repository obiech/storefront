import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/injection.dart';
import 'package:storefront_app/features/address/index.dart';

part './parts/address_delete_button.dart';
part './parts/address_google_map.dart';
part './parts/address_name_field.dart';
part './parts/address_note_field.dart';
part './parts/primary_address_checkbox.dart';
part './parts/recipient_name_field.dart';
part './parts/recipient_phone_number_field.dart';
part 'keys.dart';
part 'parts/remove_address_bottomsheet.dart';
part 'wrapper.dart';

class AddressDetailPage extends StatefulWidget {
  const AddressDetailPage({Key? key}) : super(key: key);

  @override
  State<AddressDetailPage> createState() => _AddressDetailPageState();
}

class _AddressDetailPageState extends State<AddressDetailPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: context.res.strings.addressDetail,
      actions: [
        BlocBuilder<AddressDetailBloc, AddressDetailState>(
          buildWhen: (p, c) => p.isEditMode != c.isEditMode,
          builder: (context, state) {
            return state.isEditMode
                ? const DeleteAddressButton()
                : const SizedBox();
          },
        ),
      ],
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.res.dimens.pagePadding),
          child: MultiBlocListener(
            listeners: blocListenerHandler,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          _AddressNameField(),
                          SizedBox(height: 24),
                          _AddressGoogleMapView(),
                          SizedBox(height: 24),
                          _AddressNoteField(),
                          SizedBox(height: 24),
                          _RecipientNameField(),
                          SizedBox(height: 24),
                          _RecipientPhoneNumberField(),
                          SizedBox(height: 24),
                          _PrimaryAddressCheckBox(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: BlocBuilder<AddressDetailBloc, AddressDetailState>(
                      buildWhen: (p, c) =>
                          p.loading != c.loading ||
                          p.isEditMode != c.isEditMode,
                      builder: (context, state) {
                        return DropezyButton.primary(
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
                        );
                      },
                    ),
                  ),
                ],
              ),
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
  ];
}
