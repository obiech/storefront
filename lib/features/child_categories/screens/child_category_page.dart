import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';

import '../../home/index.dart';
import '../../product/index.dart';
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
      ],
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    const products = [
      ProductModel(
        productId: 'selada-romaine-id',
        sku: 'selada-romaine-sku',
        name: 'Selada Romaine',
        price: '1500000',
        discount: '2000000',
        stock: 2,
        categoryOneId: '',
        categoryTwoId: '',
        variants: [],
        defaultProduct: '',
        thumbnailUrl:
            'https://purepng.com/public/uploads/large/purepng.com-cabbagecabbagevegetablesgreenfoodcalenonesense-481521740200e5vca.png',
      ),
      ProductModel(
        productId: 'mango-id',
        sku: 'mango-sku',
        name: 'Sweet Mangoes',
        price: '3000000',
        stock: 15,
        categoryOneId: '',
        categoryTwoId: '',
        variants: [],
        defaultProduct: '',
        thumbnailUrl:
            'https://pngimg.com/uploads/mango/small/mango_PNG9171.png',
      ),
      ProductModel(
        productId: 'irish-id',
        sku: 'irish-sku',
        name: 'Irish Potatoes',
        price: '1000000',
        stock: 50,
        categoryOneId: '',
        categoryTwoId: '',
        variants: [],
        defaultProduct: '',
        thumbnailUrl: 'https://pngimg.com/uploads/potato/potato_PNG435.png',
      ),
      ProductModel(
        productId: 'strawberry-id',
        sku: 'strawberry-sku',
        name: 'Strawberry',
        price: '4000000',
        stock: 50,
        categoryOneId: '',
        categoryTwoId: '',
        variants: [],
        defaultProduct: '',
        thumbnailUrl:
            'https://pngimg.com/uploads/strawberry/small/strawberry_PNG2615.png',
      ),
      ProductModel(
        productId: 'melon-id',
        sku: 'melon-sku',
        name: 'Melon',
        price: '6000000',
        stock: 50,
        categoryOneId: '',
        categoryTwoId: '',
        variants: [],
        defaultProduct: '',
        thumbnailUrl: 'https://pngimg.com/uploads/melon/melon_PNG14387.png',
      )
    ];

    return DropezyScaffold.textTitle(
      title: parentCategoryModel.name,
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
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 2
                        : 3,
                childAspectRatio: 13 / 25,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (BuildContext context, int index) {
                return ProductItemCard(
                  product: products[index],
                );
              },
              shrinkWrap: true,
              itemCount: products.length,
            ),
          )
        ],
      ),
    );
  }
}
