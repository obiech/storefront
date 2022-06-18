part of '../section.dart';

class OrderDetailsSectionLoading extends StatelessWidget {
  const OrderDetailsSectionLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.res.dimens.pagePadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LoadingLine(),
          SizedBox(height: context.res.dimens.spacingMiddle),
          const LoadingLine(),
          SizedBox(height: context.res.dimens.spacingMiddle),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (_, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LoadingItem(
                      height: 50,
                      width: 50,
                      borderRadius: 12.0,
                    ),
                    SizedBox(width: context.res.dimens.spacingMiddle),
                    Flexible(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const LoadingLine(),
                          SizedBox(height: context.res.dimens.spacingMiddle),
                          const LoadingLine(),
                        ],
                      ),
                    ),
                    SizedBox(width: context.res.dimens.spacingSmlarge),
                    const Flexible(
                      flex: 2,
                      child: LoadingLine(),
                    ),
                  ],
                );
              },
              separatorBuilder: (_, __) => SizedBox(
                height: context.res.dimens.spacingSmlarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
