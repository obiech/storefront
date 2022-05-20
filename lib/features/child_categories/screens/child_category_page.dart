import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/injection.dart';

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
      actions: [
        IconButton(
          onPressed: () {
            context.router.push(const GlobalSearchRoute());
          },
          icon: const Icon(DropezyIcons.search),
        )
      ],
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.23,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.only(
                left: context.res.dimens.spacingMedium,
                right: context.res.dimens.spacingMedium,
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
          Expanded(
            child: BlocBuilder<CategoryProductCubit, CategoryProductState>(
              builder: (context, state) {
                if (state is LoadedCategoryProductState) {
                  // TODO (Jonathan) : Move to its own Widget in STOR-398
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 2
                          : 3,
                      childAspectRatio: 13 / 25,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return ProductItemCard(
                        product: state.productModelList[index],
                      );
                    },
                    shrinkWrap: true,
                    itemCount: state.productModelList.length,
                  );
                } else if (state is LoadingCategoryProductState) {
                  // TODO (Jonathan) : Use card loading in search page for STOR-398
                  return const Text('Loading');
                } else if (state is ErrorCategoryProductState) {
                  // TODO (Jonathan) : Use search error Widget in STOR-398
                  return Text(
                    state.message,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: context.res.colors.red,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          )
        ],
      ),
    );
  }
}
