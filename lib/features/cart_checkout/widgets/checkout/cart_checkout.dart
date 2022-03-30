import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/shared_widgets/widgets.dart';
import '../../../../core/utils/string.ext.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: DropezyColors.white,
        boxShadow: [
          BoxShadow(
            color: DropezyColors.black.withOpacity(.1),
            blurRadius: 16,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
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
                          style: DropezyTextStyles.caption1
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        if (discount != null)
                          Text(
                            discount!.toCurrency(),
                            key: const ValueKey(CheckoutKeys.discount),
                            style: DropezyTextStyles.caption2.copyWith(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                    textStyle: DropezyTextStyles.button.copyWith(fontSize: 14),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    onPressed: () {
                      // TODO - Launch payment web-link
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
