part of '../order_payment_summary.dart';

//TODO (leovinsen): Update design when it's finalized
class OrderPaymentSummarySkeleton extends StatelessWidget {
  const OrderPaymentSummarySkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: context.res.dimens.pagePadding),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (_, __) {
        return SkeletonItem(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 9,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 60),
              Flexible(
                flex: 3,
                child: SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 9,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, __) {
        return SizedBox(height: context.res.dimens.spacingMedium);
      },
    );
  }
}
