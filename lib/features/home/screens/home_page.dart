import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/injection.dart';

import '../_exporter.dart';

part 'keys.dart';

class HomePage extends StatelessWidget {
  static const routeName = 'home';

  const HomePage({Key? key}) : super(key: key);

  //TODO: Implement HomeScreen
  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return DropezyScaffold.textTitle(
      title: 'Home',
      childPadding: const EdgeInsets.all(16),
      actions: [
        TextButton(
          onPressed: () {
            getIt<IPrefsRepository>().setIsOnBoarded(false);
            context.router.replaceAll([const OnboardingRoute()]);
          },
          child: Text(
            'Sign out',
            style: res.styles.caption1.copyWith(
              color: res.colors.white,
            ),
          ),
        )
      ],
      child: ListView(
        children: [
          ListTile(
            title: const Text('Cart Checkout'),
            onTap: () {
              context.router.push(const CartCheckoutRoute());
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Order History'),
            onTap: () {
              context.router.push(const OrderHistoryRoute());
            },
          ),
          const Divider(),
          BlocBuilder<CategoriesOneCubit, CategoriesOneState>(
            builder: _categoriesOneWidget,
          ),
        ],
      ),
    );
  }

  Widget _categoriesOneWidget(
    BuildContext context,
    CategoriesOneState state,
  ) {
    if (state is LoadingCategoriesOneState) {
      return const Center(
        key: ValueKey(HomePageKeys.loadingCategoryOneWidget),
        child: CircularProgressIndicator(),
      );
    } else if (state is LoadedCategoriesOneState) {
      return GridView.builder(
        shrinkWrap: true,
        key: const ValueKey(HomePageKeys.categoryOneListWidget),
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
        itemCount: state.categoryOneList.length,
        itemBuilder: (context, index) {
          return GridTile(
            child: GestureDetector(
              // onTap: () {
              //   context.router.push(const CategoriesTwoRoute());
              // },
              child: Column(
                children: <Widget>[
                  Flexible(
                    flex: 3,
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(
                                int.parse(
                                  '0xFF${state.categoryOneList[index].color}',
                                ),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: CachedNetworkImage(
                                imageUrl:
                                    state.categoryOneList[index].thumbnailUrl,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    flex: 2,
                    child: Text(
                      state.categoryOneList[index].name,
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
    } else if (state is ErrorLoadingCategoriesOneState) {
      return Center(
        key: const ValueKey(HomePageKeys.errorCategoryOneWidget),
        child: Text(
          state.message,
          style: context.res.styles.caption1,
        ),
      );
    }
    return Container();
  }
}
