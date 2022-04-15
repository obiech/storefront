part of '../widget.dart';

/// Widget that shows the current order's delivery progress.
///
/// Consists of three statuses:
/// - In progress
/// - In delivery
/// - Arrived at destination
///
/// that are connected by [_Bar]s
class DeliveryProgressBar extends StatelessWidget {
  const DeliveryProgressBar({
    Key? key,
    required this.orderStatus,
  }) : super(key: key);

  final OrderStatus orderStatus;

  /// maps statuses to integers between [0..2]
  /// to avoid excessive switch cases in build method
  int get statusAsIndex {
    switch (orderStatus) {
      case OrderStatus.paid:
        return 0;
      case OrderStatus.inDelivery:
        return 1;
      case OrderStatus.arrived:
        return 2;
      default:
        throw ArgumentError(
          'DeliveryProgressBar accepts only statuses '
          'paid, inDelivery, and arrived',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DeliveryStatusIndicator(
          iconData: DropezyIcons.package,
          isActive: true, // always active
          label: context.res.strings.inProcess,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: _FirstConnector(statusIndex: statusAsIndex),
        ),
        _DeliveryStatusIndicator(
          iconData: DropezyIcons.delivery,
          isActive: statusAsIndex >= 1,
          label: context.res.strings.inDelivery,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: _SecondConnector(statusIndex: statusAsIndex),
        ),
        _DeliveryStatusIndicator(
          iconData: DropezyIcons.pin,
          isActive: statusAsIndex >= 2,
          label: context.res.strings.arrived,
        ),
      ],
    );
  }
}

/// The first connector between in progress status
/// and in delivery status
class _FirstConnector extends StatelessWidget {
  const _FirstConnector({
    Key? key,
    required this.statusIndex,
  }) : super(key: key);

  final int statusIndex;

  @override
  Widget build(BuildContext context) {
    return statusIndex == 0
        ? const _StackedInProgressBar()
        : _Bar.activeBar(context.res);
  }
}

/// The second connector between in delivery status
/// and arrived at destination status
class _SecondConnector extends StatelessWidget {
  const _SecondConnector({
    Key? key,
    required this.statusIndex,
  }) : super(key: key);

  final int statusIndex;

  @override
  Widget build(BuildContext context) {
    switch (statusIndex) {
      case 0:
        return _Bar.inactiveBar(context.res);
      case 1:
        return const _StackedInProgressBar();
      case 2:
        return _Bar.activeBar(context.res);
    }

    return Container();
  }
}
