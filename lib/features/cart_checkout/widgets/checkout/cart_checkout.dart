import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

import '../../../../res/resources.dart';
import '../../index.dart';
import '../payment_method/selector.dart';
import 'keys.dart';

/// A checkout widget for the cart
///
/// Provides payment selection and processing
/// for different payment providers & 3rd parties
class CartCheckout extends StatelessWidget {
  /// The overall cart price
  final String price;

  /// The overall cart discount
  final String? discount;

  /// The points to be won on successful checkout
  final String? points;

  /// The customer's preferred payment method
  final String? preferredPayment;

  const CartCheckout({
    Key? key,
    required this.price,
    this.discount,
    this.points,
    this.preferredPayment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = Resources.of(context);
    return Container(
      decoration: res.styles.bottomSheetStyle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10, bottom: 10, right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          price.toCurrency(),
                          key: const ValueKey(CheckoutKeys.price),
                          style: res.styles.caption1
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        if (discount != null)
                          Text(
                            discount!.toCurrency(),
                            key: const ValueKey(CheckoutKeys.discount),
                            style: res.styles.caption2.copyWith(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: PaymentMethodSelector(
                    key: const ValueKey(CheckoutKeys.payment),
                    onChange: (method) {
                      // TODO - Use payment method response
                    },
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 9.5),
                  child: DropezyButton.primary(
                    key: const ValueKey(CheckoutKeys.buy),
                    label: 'Bayar',
                    textStyle: res.styles.button.copyWith(fontSize: 14),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    onPressed: () async {
                      // TODO - Launch payment web-link
                      Navigator.of(context).pushNamed(
                        OrderSuccessfulPage.routeName,
                      );
                      /*try {
                        final opened = await launch(
                          'gojek://gopay/merchanttransfer?tref=1509110800474199656LMVO&amount=10000&activity=GP:RR&callback_url=someapps://callback?order_id=SAMPLE-ORDER-ID-01',
                        );

                        if (!opened) {
                          throw PlatformException(code: 'ACTIVITY_NOT_FOUND');
                        }
                      } on PlatformException catch (e) {
                        if (e.code == 'ACTIVITY_NOT_FOUND') {
                          await launch(
                            Platform.isAndroid
                                ? 'https://play.google.com/store/apps/details?id=com.gojek.app'
                                : 'https://apps.apple.com/us/app/gojek/id944875099',
                          );
                        }
                      }*/
                    },
                  ),
                )
              ],
            ),
          ),
          if (points != null)
            Container(
              key: const ValueKey(CheckoutKeys.points),
              padding: const EdgeInsets.symmetric(vertical: 5),
              color: DropezyColors.lightOrange,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/icons/coin.png'),
                    const SizedBox(
                      width: 5,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Kamu akan mendapatkan ',
                        style: const TextStyle(
                          color: DropezyColors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 10.0,
                        ),
                        children: [
                          TextSpan(
                            text: '${points!.toIDRFormat()} coins',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
