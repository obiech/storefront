import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:storefront_app/core/core.dart';

import '../widgets/widgets.dart';

class OrderSuccessfulPage extends StatelessWidget {
  const OrderSuccessfulPage({Key? key}) : super(key: key);
  static const routeName = 'order-successful';

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return DropezyScaffold(
      title: Text(
        res.strings.orderSuccessful,
        style: res.styles.button,
      ),
      useWhiteBody: true,
      centerTitle: true,
      childPadding: 0,
      bodyColor: res.colors.blue,
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
                  'Ngeng... ${res.strings.yourOrderWillArriveIn}',
                  style: res.styles.caption1.copyWith(
                    fontWeight: FontWeight.w700,
                    color: res.colors.white,
                  ),
                ),
                Text(
                  res.strings.minutes(20),
                  style: res.styles.caption1.copyWith(
                    fontWeight: FontWeight.w700,
                    color: res.colors.white,
                    fontSize: 36,
                  ),
                ),
                SizedBox(
                  height: res.dimens.spacingMxlarge,
                ),
                Image.asset('assets/images/order_success.png')
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
                  Text(
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
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: DropezyButton.primary(
                      label: res.strings.viewOrderDetails,
                      textStyle: res.styles.button,
                      onPressed: () {},
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
