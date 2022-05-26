import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/injection.dart';
import 'package:storefront_app/features/address/index.dart';

part 'keys.dart';
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
                              ),
                              const SizedBox(height: 24),
                              DropezyTextFormField(
                                fieldKey:
                                    AddressDetailPageKeys.addressDetailField,
                                label: context.res.strings.addressDetail,
                                hintText: context.res.strings.addressDetailHint,
                                onChanged: (addressDetail) {
                                  context
                                      .read<AddressDetailBloc>()
                                      .add(AddressDetailChanged(addressDetail));
                                },
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
                            if (!_formKey.currentState!.validate()) {
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
      listener: (context, state) {
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
