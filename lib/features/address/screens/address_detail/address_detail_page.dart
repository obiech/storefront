import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

part 'keys.dart';

class AddressDetailPage extends StatefulWidget {
  const AddressDetailPage({Key? key}) : super(key: key);

  @override
  State<AddressDetailPage> createState() => _AddressDetailPageState();
}

class _AddressDetailPageState extends State<AddressDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _primaryAddressNotifier =
      ValueNotifier<bool>(false);

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
          child: Form(
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
                          fieldKey: AddressDetailPageKeys.addressNameField,
                          label: context.res.strings.addressName,
                          hintText: context.res.strings.addressNameHint,
                        ),
                        const SizedBox(height: 24),
                        DropezyTextFormField(
                          fieldKey: AddressDetailPageKeys.addressDetailField,
                          label: context.res.strings.addressDetail,
                          hintText: context.res.strings.addressDetailHint,
                        ),
                        const SizedBox(height: 24),
                        DropezyTextFormField(
                          fieldKey: AddressDetailPageKeys.recipientNameField,
                          label: context.res.strings.recipientName,
                          hintText: context.res.strings.recipientNameHint,
                        ),
                        const SizedBox(height: 24),
                        DropezyTextFormField(
                          fieldKey: AddressDetailPageKeys.phoneNumberField,
                          label: context.res.strings.phoneNumber,
                          hintText: context.res.strings.phoneNumberHint,
                        ),
                        const SizedBox(height: 24),
                        ValueListenableBuilder<bool>(
                          valueListenable: _primaryAddressNotifier,
                          builder: (context, value, child) {
                            return CheckboxListTile(
                              key: AddressDetailPageKeys.primaryAddressCheckbox,
                              value: value,
                              title:
                                  Text(context.res.strings.usePrimaryAddress),
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                              onChanged: (newValue) {
                                _primaryAddressNotifier.value = newValue!;
                              },
                            );
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
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      // TODO (widy): pass inputted address to bloc
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
