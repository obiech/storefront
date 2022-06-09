import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';

import '../index.dart';

class ParentCategoriesGrid extends StatelessWidget {
  const ParentCategoriesGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParentCategoriesCubit, ParentCategoriesState>(
      builder: (context, state) {
        // TODO (Jonathan) : try to find better solving
        // Iphone 13 screen height is 667
        final screenSize = MediaQuery.of(context).size.height;

        final appBarHeight = context.res.dimens.appBarSize;

        // Navbar height is 56
        final navBarHeight = screenSize * 0.08;

        // Search Area height is 180
        final searchHeight = screenSize * 0.28;

        final parentCategoriesHeight =
            screenSize - (appBarHeight + navBarHeight + searchHeight);

        if (state is LoadingParentCategoriesState) {
          return SizedBox(
            // TODO (Jonathan) : implements skeleton
            height: parentCategoriesHeight,
            child: const Center(
              key: ValueKey(HomePageKeys.loadingparentCategoryWidget),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is LoadedParentCategoriesState) {
          return SizedBox(
            height: parentCategoriesHeight,
            child: GridView.builder(
              shrinkWrap: true,
              key: const ValueKey(HomePageKeys.parentCategoryGridWidget),
              physics: const NeverScrollableScrollPhysics(),
              //TODO (Jonathan): update into dynamic
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 100,
                childAspectRatio: 3 / 5,
                // mainAxisExtent: 140,
                crossAxisSpacing: 16,
                mainAxisSpacing: 12,
              ),
              padding: EdgeInsets.zero,
              itemCount: state.parentCategoryList.length,
              itemBuilder: (context, index) {
                return GridTile(
                  child: GestureDetector(
                    onTap: () {
                      context.router.push(
                        ChildCategoriesRoute(
                          parentCategoryModel: state.parentCategoryList[index],
                        ),
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        Flexible(
                          flex: 3,
                          child: DropezyImage(
                            url: state.parentCategoryList[index].thumbnailUrl,
                            borderRadius: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Flexible(
                          flex: 2,
                          child: Text(
                            state.parentCategoryList[index].name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is ErrorLoadingParentCategoriesState) {
          return Center(
            key: const ValueKey(HomePageKeys.errorParentCategoryWidget),
            child: Text(
              state.message,
              style: context.res.styles.caption1,
            ),
          );
        }
        return Container();
      },
    );
  }
}
