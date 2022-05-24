part of '../help_page.dart';

class _CustomerServiceTile extends StatelessWidget {
  const _CustomerServiceTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        context.res.dimens.pagePadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.res.strings.contactUs,
            style: context.res.styles.subtitle,
          ),
          SizedBox(
            height: context.res.dimens.spacingMiddle,
          ),
          Container(
            padding: EdgeInsets.all(context.res.dimens.spacingMiddle),
            decoration: BoxDecoration(
              color: context.res.colors.lightBlue,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.res.strings.customerService,
                      style: context.res.styles.caption1,
                    ),
                    Text(
                      '+${ExternalUrlConfig.customerServiceWhatsApp}',
                      style: context.res.styles.subtitle
                          .copyWith(fontSize: context.res.dimens.smallText),
                    )
                  ],
                ),
                const _WhatsAppButton()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
