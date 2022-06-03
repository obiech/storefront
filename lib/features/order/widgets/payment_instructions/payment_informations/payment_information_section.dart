import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storefront_app/core/core.dart';

import '../../../../../res/resources.dart';
import '../../../index.dart';

part 'keys.dart';
part 'parts/list_tile.dart';
part 'parts/payment_reminder.dart';

class PaymentInformationSection extends StatelessWidget {
  const PaymentInformationSection({
    Key? key,
    required this.order,
    this.currentTime,
  }) : super(key: key);

  final OrderModel order;

  // Used for mocking current time in tests
  final DateTime? currentTime;

  @override
  Widget build(BuildContext context) {
    final expireTime = order.paymentExpiryTime ?? DateTime.now();
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.res.dimens.pagePadding,
        19.5,
        context.res.dimens.pagePadding,
        context.res.dimens.pagePadding,
      ),
      child: Column(
        children: [
          // Illustration image for waiting
          SvgPicture.asset(
            context.res.paths.imageDropezyWaitingPayment,
            key: const ValueKey(PaymentInformationSectionKeys.illustrationSVG),
          ),
          const SizedBox(height: 12),
          Text(
            context.res.strings.finishPaymentBefore,
            key: const ValueKey(
              PaymentInformationSectionKeys.finishPaymentBefore,
            ),
            style: context.res.styles.caption2
                .copyWith(fontWeight: FontWeight.w400)
                .withLineHeight(18),
          ),

          // Waiting Payment date expiry
          Text(
            expireTime.formatDDMMYYhhmm(),
            //dateFormat.format(expireTime),
            key: const ValueKey(PaymentInformationSectionKeys.expiryTime),
            style: context.res.styles.caption2
                .copyWith(fontWeight: FontWeight.w500)
                .withLineHeight(20),
          ),

          //Timer countdown
          CountdownBuilder(
            key: const ValueKey(PaymentInformationSectionKeys.countdown),
            countdownDuration: order.paymentExpiryTime!
                .difference(currentTime ?? DateTime.now())
                .inSeconds,
            builder: (seconds) {
              return TimingText(
                color: context.res.colors.orange,
                timeLabel: Duration(seconds: seconds).toHhMmSs(),
                iconData: DropezyIcons.time,
              );
            },
          ),

          const SizedBox(height: 24),
          const PaymentReminderContainer(
            key: ValueKey(
              PaymentInformationSectionKeys.processOrderAfterVerify,
            ),
          ),
          const SizedBox(height: 24),
          InformationsTile.paymentMethod(
            key: const ValueKey(
              PaymentInformationSectionKeys.paymentMethodTile,
            ),
            res: context.res,
            // TODO (Jonathan) : make paymentMethod receive from order
            paymentMethod: 'BCA Virtual Account',
          ),
          InformationsTile.virtualAccount(
            key: const ValueKey(
              PaymentInformationSectionKeys.virtualAccountTile,
            ),
            ctx: context,
            res: context.res,
            virtualAccount: '123456789',
          ),
          InformationsTile.totalBill(
            key: const ValueKey(
              PaymentInformationSectionKeys.totalBillTile,
            ),
            res: context.res,
            amount: order.total,
          ),
        ],
      ),
    );
  }
}
