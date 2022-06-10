import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';
import 'package:storefront_app/core/core.dart';

import '../../../../res/resources.dart';
import '../../index.dart';
import '../payment_method/selector.dart';
import 'checkout_button.dart';
import 'keys.dart';

part './part/checkout_details.dart';
part './part/checkout_details_skeleton.dart';
part './part/slashed_amount_text.dart';
part './part/price_amount_text.dart';

/// A checkout widget for the cart
///
/// Provides payment selection and processing
/// for different payment providers & 3rd parties
class CartCheckout extends StatelessWidget {
  const CartCheckout({Key? key}) : super(key: key);

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
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      right: 12,
                    ),
                    child: CheckoutDetails(),
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 9.5),
                  child: CheckoutButton(),
                )
              ],
            ),
          ),

          // if (points != null)
          //   Container(
          //     key: const ValueKey(CheckoutKeys.points),
          //     padding: const EdgeInsets.symmetric(vertical: 5),
          //     color: DropezyColors.lightOrange,
          //     child: Center(
          //       child: Row(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           Image.asset('assets/icons/coin.png'),
          //           const SizedBox(
          //             width: 5,
          //           ),
          //           RichText(
          //             text: TextSpan(
          //               text: 'Kamu akan mendapatkan ',
          //               style: const TextStyle(
          //                 color: DropezyColors.black,
          //                 fontWeight: FontWeight.w300,
          //                 fontSize: 10.0,
          //               ),
          //               children: [
          //                 TextSpan(
          //                   text: '${points!.toIDRFormat()} coins',
          //                   style: const TextStyle(
          //                     fontWeight: FontWeight.w600,
          //                   ),
          //                 )
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   )
        ],
      ),
    );
  }
}
