part of '../cart_checkout.dart';

class CheckoutDetailSkeleton extends StatelessWidget {
  const CheckoutDetailSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonItem(
      child: Column(
        children: [
          SkeletonLine(
            style: SkeletonLineStyle(
              height: 12,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 9),
          SkeletonLine(
            style: SkeletonLineStyle(
              height: 12,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}
