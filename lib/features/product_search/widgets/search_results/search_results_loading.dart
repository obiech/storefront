import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

class SearchResultsLoading extends StatelessWidget {
  const SearchResultsLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;

    return GridView.builder(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: res.dimens.spacingLarge,
        vertical: res.dimens.spacingLarge,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.portrait ? 3 : 4,
        childAspectRatio: 13 / 25,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (BuildContext context, int index) {
        return const ProductItemCardLoading();
      },
      shrinkWrap: true,
      itemCount:
          MediaQuery.of(context).orientation == Orientation.portrait ? 6 : 4,
    );
  }
}
