part of '../address_detail_page.dart';

class _RecipientPhoneNumberField extends StatelessWidget {
  const _RecipientPhoneNumberField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressDetailBloc, AddressDetailState>(
      /// Will only rebuild when [LoadDeliveryAddress] called first time
      /// to set initial value
      buildWhen: (p, c) => p.isEditMode != c.isEditMode,
      builder: (context, state) {
        return DropezyTextFormField(
          key: UniqueKey(),
          fieldKey: AddressDetailPageKeys.phoneNumberField,
          initialValue: state.recipientPhoneNumber,
          label: context.res.strings.phoneNumber,
          hintText: context.res.strings.phoneNumberHint,
          onChanged: (phoneNumber) {
            context
                .read<AddressDetailBloc>()
                .add(RecipientPhoneChanged(phoneNumber));
          },
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.phone,
        );
      },
    );
  }
}
