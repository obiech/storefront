import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';

import '../../index.dart';

part 'parts/image.dart';
part 'parts/text.dart';

class ChildCategoriesList extends StatelessWidget {
  const ChildCategoriesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return BlocBuilder<ChildCategoryCubit, ChildCategoryState>(
      builder: (context, state) {
        return ListView.builder(
          key: const ValueKey(ChildCategoryKeys.childCategoryListWidget),
          shrinkWrap: true,
          itemCount: state.childCategoriesList.length,
          itemBuilder: (context, index) {
            final childCategory = state.childCategoriesList[index];
            final isActive = state.selectedChildCategory.categoryId ==
                childCategory.categoryId;

            return GestureDetector(
              onTap: () {
                if (childCategory != state.selectedChildCategory) {
                  context.read<ChildCategoryCubit>().setActiveChildCategory(
                        childCategory,
                      );
                  context
                      .read<CategoryProductCubit>()
                      .fetchCategoryProduct(childCategory.categoryId);
                }
              },
              child: Column(
                children: [
                  SizedBox(height: res.dimens.spacingMedium),
                  AspectRatio(
                    aspectRatio: 23 / 25,
                    child: _ChildCategoriesImage(
                      url: childCategory.thumbnailUrl,
                      isActive: isActive,
                    ),
                  ),
                  _ChildCategoriesText(
                    name: childCategory.name,
                    isActive: isActive,
                  ),
                  SizedBox(height: res.dimens.spacingMedium),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
