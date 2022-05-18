import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';

import '../../index.dart';

class ProductCategoryGrid extends StatelessWidget {
  const ProductCategoryGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int columns = MediaQuery.of(context).size.width < 600 ? 2 : 4;

    /// Product Card Scale factor for X columns
    /// * 12 margin between columns
    /// * 0.005 scale factor to fit the
    /// category product page
    final double scaleFactor =
        ((MediaQuery.of(context).size.width - (12 * columns)) / columns) *
            0.005;

    return BlocBuilder<CategoryProductCubit, CategoryProductState>(
      builder: (context, state) {
        if (state is LoadedCategoryProductState) {
          return ProductGridView(
            key: const ValueKey(ChildCategoryKeys.productCategoryGridWidget),
            columns: columns,
            productModelList: state.productModelList,
            scaleFactor: scaleFactor,
          );
        } else if (state is LoadingCategoryProductState) {
          return ProductGridLoading(
            scaleFactor: scaleFactor,
            columns: columns,
            rows: 3,
          );
        } else if (state is ErrorCategoryProductState) {
          return DropezyError(
            title: context.res.strings.failed,
            message: state.message,
          );
        }
        return const SizedBox();
      },
    );
  }
}
