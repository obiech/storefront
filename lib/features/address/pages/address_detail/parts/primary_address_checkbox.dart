part of '../address_detail_page.dart';

class _PrimaryAddressCheckBox extends StatelessWidget {
  const _PrimaryAddressCheckBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressDetailBloc, AddressDetailState>(
      buildWhen: (p, c) => p.isPrimaryAddress != c.isPrimaryAddress,
      builder: (context, state) {
        return CheckboxListTile(
          key: AddressDetailPageKeys.primaryAddressCheckbox,
          value: state.isPrimaryAddress,
          title: Text(context.res.strings.usePrimaryAddress),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          onChanged: (newValue) {
            context
                .read<AddressDetailBloc>()
                .add(PrimaryAddressChanged(newValue!));
          },
        );
      },
    );
  }
}
