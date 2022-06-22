import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';
import 'package:storefront_app/core/core.dart';

import '../../index.dart';

part 'parts/parent_categories_item_loading.dart';
part 'parts/parent_grid_loading.dart';

class ParentCategoriesGrid extends StatelessWidget {
  const ParentCategoriesGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Column count for phone 4 and tablet 7
    final int columns = MediaQuery.of(context).size.width < 600 ? 4 : 7;

    // Horizontal spacing for phone 16 and tablet 35
    final horizontalSpacing =
        MediaQuery.of(context).size.width < 600 ? 16.0 : 35.0;

    // Vertical spacing for phone 12 and tablet 25
    final verticalSpacing =
        MediaQuery.of(context).size.width < 600 ? 12.0 : 25.0;

    return BlocBuilder<ParentCategoriesCubit, ParentCategoriesState>(
      builder: (context, state) {
        if (state is LoadingParentCategoriesState) {
          return ParentLoadingGrid(
            key: const ValueKey(HomePageKeys.loadingparentCategoryWidget),
            columns: columns,
            rows: 3,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing,
          );
        } else if (state is LoadedParentCategoriesState) {
          return GridView.builder(
            shrinkWrap: true,
            key: const ValueKey(HomePageKeys.parentCategoryGridWidget),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              childAspectRatio: 8 / 13,
              crossAxisSpacing: horizontalSpacing,
              mainAxisSpacing: verticalSpacing,
            ),
            padding: EdgeInsets.only(
              top: context.res.dimens.spacingLarge,
              bottom: context.res.dimens.minOffsetForCartSummary,
            ),
            itemCount: state.parentCategoryList.length,
            itemBuilder: (context, index) {
              // Using fixed width since phone and tablet size is the same
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
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      DropezyImage(
                        padding: EdgeInsets.zero,
                        url: state.parentCategoryList[index].thumbnailUrl,
                        borderRadius: 16,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        state.parentCategoryList[index].name,
                        textAlign: TextAlign.center,
                        style: context.res.styles.caption3
                            .copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: DropezyColors.grey6,
                            )
                            .withLineHeight(13),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (state is ErrorLoadingParentCategoriesState) {
          return DropezyError(
            key: const ValueKey(HomePageKeys.errorParentCategoryWidget),
            title: context.res.strings.failed,
            message: state.message,
          );
        }
        return Container();
      },
    );
  }
}
