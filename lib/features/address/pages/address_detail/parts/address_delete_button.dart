part of '../address_detail_page.dart';

class DeleteAddressButton extends StatelessWidget {
  const DeleteAddressButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDropezyBottomSheet(context, (_) {
          return const RemoveAddressBottomSheet();
        });
      },
      icon: const Icon(DropezyIcons.trash),
    );
  }
}
