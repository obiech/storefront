import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
import 'package:storefront_app/core/core.dart';

/// Loading status for product tem card.
class ProductItemCardLoading extends StatelessWidget {
  const ProductItemCardLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: res.colors.boxShadow.withOpacity(.3),
            blurRadius: 16,
            spreadRadius: 3,
          ),
        ],
        borderRadius: BorderRadius.circular(res.dimens.spacingLarge),
        color: res.colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(res.dimens.spacingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonItem(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(res.dimens.spacingLarge),
                child: Container(
                  color: res.colors.lightBlue,
                  padding: EdgeInsets.all(res.dimens.spacingMiddle),
                  child: const AspectRatio(
                    aspectRatio: 1,
                    child: SizedBox(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: res.dimens.spacingSmall,
            ),
            SkeletonParagraph(
              style: SkeletonParagraphStyle(
                lines: 4,
                spacing: 4,
                lineStyle: SkeletonLineStyle(
                  height: 9,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            SkeletonParagraph(
              style: SkeletonParagraphStyle(
                lines: 1,
                lineStyle: SkeletonLineStyle(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
