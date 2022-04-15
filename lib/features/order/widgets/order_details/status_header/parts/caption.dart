part of '../widget.dart';

/// Displays a description of current order status
class OrderStatusCaption extends StatelessWidget {
  const OrderStatusCaption({
    Key? key,
    required this.orderStatus,
  }) : super(key: key);

  final OrderStatus orderStatus;

  @override
  Widget build(BuildContext context) {
    late String caption;

    switch (orderStatus) {
      case OrderStatus.paid:
        caption = context.res.strings.captionOrderInProcess;
        break;
      case OrderStatus.inDelivery:
        caption = context.res.strings.captionOrderInDelivery;
        break;
      case OrderStatus.arrived:
        caption = context.res.strings.captionOrderHasArrived;
        break;
      default:
        caption = '';
        break;
    }
    return Container(
      padding: EdgeInsets.all(context.res.dimens.spacingMedium),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.res.colors.paleYellow,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        caption,
        style: context.res.styles.caption3.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
