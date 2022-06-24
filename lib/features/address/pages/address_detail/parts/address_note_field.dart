part of '../address_detail_page.dart';

class _AddressNoteField extends StatelessWidget {
  const _AddressNoteField({
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
          fieldKey: AddressDetailPageKeys.addressDetailField,
          initialValue: state.addressDetailsNote,
          label: context.res.strings.addressDetail,
          hintText: context.res.strings.addressDetailHint,
          onChanged: (addressDetail) {
            context
                .read<AddressDetailBloc>()
                .add(AddressDetailNoteChanged(addressDetail));
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
