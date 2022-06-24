part of '../address_detail_page.dart';

class _RecipientNameField extends StatelessWidget {
  const _RecipientNameField({
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
          fieldKey: AddressDetailPageKeys.recipientNameField,
          initialValue: state.recipientName,
          label: context.res.strings.recipientName,
          hintText: context.res.strings.recipientNameHint,
          onChanged: (name) {
            context.read<AddressDetailBloc>().add(RecipientNameChanged(name));
          },
          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.sentences,
          inputFormatters: [UpperCaseTextFormatter()],
        );
      },
    );
  }
}
