part of '../address_detail_page.dart';

class _AddressNameField extends StatelessWidget {
  const _AddressNameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressDetailBloc, AddressDetailState>(
      /// Will only rebuild when [LoadDeliveryAddress] called first time
      /// to set initial value
      buildWhen: (p, c) => p.isEditMode != c.isEditMode,
      builder: (context, state) {
        return DropezyTextFormField(
          key: UniqueKey(),
          fieldKey: AddressDetailPageKeys.addressNameField,
          initialValue: state.addressName,
          label: context.res.strings.addressName,
          hintText: context.res.strings.addressNameHint,
          onChanged: (name) {
            context.read<AddressDetailBloc>().add(AddressNameChanged(name));
          },
          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}