part of '../payment_information_section.dart';

class InformationsTile extends StatelessWidget {
  const InformationsTile({
    Key? key,
    required this.title,
    required this.subtitle,
    this.trailing,
  }) : super(key: key);

  final String title;
  final Widget subtitle;
  final Widget? trailing;

  factory InformationsTile.paymentMethod({
    Key? key,
    required Resources res,
    required String paymentMethod,
  }) {
    return InformationsTile(
      key: key,
      title: res.strings.paymentMethod,
      subtitle: Row(
        children: [
          SvgPicture.asset(
            res.paths.bca,
            key: const ValueKey(InformationsTileKeys.subtitleLogo),
          ),
          const SizedBox(width: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Text(
              paymentMethod,
              key: const ValueKey(InformationsTileKeys.subtitleText),
              style: res.styles.caption1
                  .copyWith(
                    fontWeight: FontWeight.w600,
                  )
                  .withLineHeight(22),
            ),
          ),
        ],
      ),
    );
  }

  factory InformationsTile.virtualAccount({
    Key? key,
    required BuildContext ctx,
    required String virtualAccount,
  }) {
    return InformationsTile(
      key: key,
      title: ctx.res.strings.virtualAccountNumber,
      subtitle: Text(
        virtualAccount,
        key: const ValueKey(InformationsTileKeys.subtitleText),
        style: ctx.res.styles.caption1
            .copyWith(
              fontWeight: FontWeight.w600,
            )
            .withLineHeight(22),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(top: 13.0),
        child: TextButton(
          key: const ValueKey(InformationsTileKeys.button),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: virtualAccount)).then((_) {
              ctx.showToast(
                ctx.res.strings.copiedSuccessfully(
                  ctx.res.strings.virtualAccount,
                ),
              );
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.copy,
                size: 16,
                color: DropezyColors.blue,
              ),
              const SizedBox(width: 5),
              Text(
                ctx.res.strings.copy,
                style: ctx.res.styles.caption2
                    .copyWith(
                      fontWeight: FontWeight.w600,
                      color: DropezyColors.blue,
                    )
                    .withLineHeight(16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  factory InformationsTile.totalBill({
    Key? key,
    required String amount,
    required BuildContext ctx,
    required OrderModel order,
  }) {
    return InformationsTile(
      key: key,
      title: ctx.res.strings.totalBill,
      subtitle: Text(
        amount.toCurrency(),
        key: const ValueKey(InformationsTileKeys.subtitleText),
        style: ctx.res.styles.caption1
            .copyWith(
              fontWeight: FontWeight.w600,
            )
            .withLineHeight(22),
      ),
      trailing: TextButton(
        key: const ValueKey(InformationsTileKeys.button),
        onPressed: () {
          showDropezyBottomSheet(ctx, (_) {
            return OrderDetailsBottomSheet(order: order);
          });
        },
        child: Text(
          ctx.res.strings.details,
          style: ctx.res.styles.caption2
              .copyWith(
                fontWeight: FontWeight.w600,
                color: DropezyColors.blue,
              )
              .withLineHeight(16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0,
      contentPadding: EdgeInsets.zero,
      key: const ValueKey(InformationsTileKeys.tile),
      title: Text(
        title,
        key: const ValueKey(InformationsTileKeys.header),
        style: context.res.styles.caption2
            .copyWith(
              fontWeight: FontWeight.w500,
              color: context.res.colors.grey6,
            )
            .withLineHeight(20),
      ),
      subtitle: subtitle,
      trailing: trailing,
    );
  }
}
