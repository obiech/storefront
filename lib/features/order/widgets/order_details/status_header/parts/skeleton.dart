part of '../widget.dart';

class OrderStatusHeaderLoading extends StatelessWidget {
  const OrderStatusHeaderLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.res.dimens.pagePadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Flexible(
                flex: 3,
                child: LoadingLine(),
              ),
              SizedBox(width: 120),
              Flexible(
                flex: 2,
                child: LoadingLine(),
              ),
            ],
          ),
          SizedBox(height: context.res.dimens.spacingLarge),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 64),
            child: LoadingParagraph(),
          ),
          SizedBox(height: context.res.dimens.spacingMiddle),
          const LoadingLine(),
          SizedBox(height: context.res.dimens.spacingMiddle),
          const _TextRowLoading(),
          SizedBox(height: context.res.dimens.spacingMiddle),
          const _TextRowLoading(),
        ],
      ),
    );
  }
}

class _TextRowLoading extends StatelessWidget {
  const _TextRowLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Flexible(
          flex: 3,
          child: LoadingLine(),
        ),
        SizedBox(width: 120),
        Flexible(
          flex: 2,
          child: LoadingLine(),
        ),
      ],
    );
  }
}
