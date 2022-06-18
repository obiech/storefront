part of '../delivery_address_detail.dart';

class DeliveryAddressDetailSkeleton extends StatelessWidget {
  const DeliveryAddressDetailSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        context.res.dimens.pagePadding,
        12,
        context.res.dimens.pagePadding,
        context.res.dimens.pagePadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LoadingLine(),
          SizedBox(
            height: context.res.dimens.spacingLarge,
          ),
          // Loading Line for address title
          const LoadingLine(),
          SizedBox(height: context.res.dimens.spacingMiddle),

          // Loading Line for recipient name and phone number
          const LoadingLine(),
          SizedBox(height: context.res.dimens.spacingMiddle),

          // Loading Line for delivery address
          const LoadingLine(),
          SizedBox(height: context.res.dimens.spacingLarge),
          const LoadingLine(),
        ],
      ),
    );
  }
}
