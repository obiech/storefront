import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/injection.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

import '../../home/index.dart';
import '../index.dart';
import '../widgets/widgets.dart';

part 'keys.dart';

class ChildCategoriesPage extends StatelessWidget implements AutoRouteWrapper {
  const ChildCategoriesPage({
    Key? key,
    required this.parentCategoryModel,
  }) : super(key: key);

  final ParentCategoryModel parentCategoryModel;

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// Add another Bloc Provider here
        BlocProvider<ChildCategoryCubit>(
          create: (_) =>
              ChildCategoryCubit(parentCategoryModel.sortChildrenByName),
        ),
        BlocProvider<CategoryProductCubit>(
          create: (_) => getIt<CategoryProductCubit>()
            ..fetchCategoryProduct(
              parentCategoryModel.sortChildrenByName[0].categoryId,
            ),
        ),
      ],
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: parentCategoryModel.name,
      floatingActionButton: const CartSummary(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      actions: [
        IconButton(
          onPressed: () {
            context.router.push(GlobalSearchRoute());
          },
          icon: const Icon(DropezyIcons.search),
        )
      ],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.23,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.res.dimens.spacingMedium,
              ),
              child: const ChildCategoriesList(),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.02,
            child: Container(
              color: context.res.colors.grey1,
              child: VerticalDivider(
                color: context.res.colors.grey1,
                thickness: context.res.dimens.spacingSmall,
              ),
            ),
          ),
          const Expanded(child: ProductCategoryGrid()),
        ],
      ),
    );
  }
}
