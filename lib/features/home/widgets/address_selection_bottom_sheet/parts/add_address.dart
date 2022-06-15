part of '../address_selection_bottom_sheet.dart';

class AddAddress extends StatelessWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        context.pushRoute(const SearchLocationRoute());
      },
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      minLeadingWidth: 20,
      dense: true,
      leading: Icon(
        DropezyIcons.plus,
        color: context.res.colors.blue,
        size: 24,
      ),
      title: Text(
        context.res.strings.addAddress,
        style:
            context.res.styles.button.copyWith(color: context.res.colors.blue),
      ),
    );
  }
}
