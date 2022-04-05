import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

/// Displayed when an order is failed
///
/// Redirect comes from deeplink
class OrderFailurePage extends StatefulWidget {
  /// The order id from gojek app
  final String orderId;

  const OrderFailurePage({Key? key, required this.orderId}) : super(key: key);
  static const routeName = '/order/gopay/failure';

  @override
  State<OrderFailurePage> createState() => _OrderFailurePageState();
}

class _OrderFailurePageState extends State<OrderFailurePage> {
  @override
  void initState() {
    /// TODO(obella465): Check order [widget.orderId] status with backend
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return DropezyScaffold(
      title: Text(
        res.strings.orderFailed,
        style: res.styles.button,
      ),
      useWhiteBody: true,
      centerTitle: true,
      childPadding: 0,
      bodyColor: res.colors.red,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: res.dimens.spacingXxlarge,
              left: res.dimens.spacingSmlarge,
              right: res.dimens.spacingSmlarge,
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  res.strings.orderFailedMessage,
                  textAlign: TextAlign.center,
                  style: res.styles.caption1.copyWith(
                    fontWeight: FontWeight.w700,
                    color: res.colors.white,
                  ),
                ),
                SizedBox(
                  height: res.dimens.spacingMxlarge,
                ),
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 2 - 10,
                  backgroundColor: res.colors.grey3,
                  child: Text(
                    'ORDER FAILED IMAGE',
                    style: res.styles.title.copyWith(color: res.colors.white),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: res.styles.bottomSheetStyle,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                top: res.dimens.spacingLarge,
                bottom: res.dimens.bottomSheetHorizontalPadding,
                right: res.dimens.bottomSheetHorizontalPadding,
                left: res.dimens.bottomSheetHorizontalPadding,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /*Text(
                    res.strings.onThisOrderYouHaveSuccessfully,
                    style: res.styles.subtitle,
                  ),
                  SizedBox(
                    height: res.dimens.spacingMiddle,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: res.dimens.spacingMiddle,
                    ),
                    child: OrderSummaryItem(
                      icon: SvgPicture.asset(
                        res.paths.icDiscount,
                        height: res.dimens.spacingSmlarge,
                      ),
                      leading: res.strings.savedMoney,
                      trailing: '800000'.toCurrency(),
                    ),
                  ),*/
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: DropezyButton.primary(
                      label: res.strings.retry,
                      textStyle: res.styles.button,
                      onPressed: () {
                        /// TODO(obella465): Pass [widget.orderId] to page to view order details
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
