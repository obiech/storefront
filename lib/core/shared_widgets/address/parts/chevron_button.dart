part of '../delivery_address_detail.dart';

/// On tap, navigate to [ChangeAddressPage]
class ChevronRightButton extends StatelessWidget {
  const ChevronRightButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      child: IconButton(
        splashColor: context.res.colors.black,
        padding: EdgeInsets.zero,
        onPressed: () {
          context.router.push(const ChangeAddressRoute());
        },
        icon: Icon(
          DropezyIcons.chevron_right,
          color: context.res.colors.black,
          size: 16,
        ),
      ),
    );
  }
}
