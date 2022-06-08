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
        if (state is LoadingParentCategoriesState) {
          return SizedBox(
            // TODO (Jonathan) : implements skeleton
            height: MediaQuery.of(context).size.height * .40,
            child: const Center(
              key: ValueKey(HomePageKeys.loadingparentCategoryWidget),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is LoadedParentCategoriesState) {
          return GridView.builder(
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
