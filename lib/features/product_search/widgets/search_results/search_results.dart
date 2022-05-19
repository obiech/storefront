import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product/index.dart';

import '../../index.dart';

class SearchResults extends StatefulWidget {
  const SearchResults({Key? key}) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  final _scrollController = ScrollController();
  late double aspectRatio;
  late double horizontalSpacing;
  late double verticalSpacing;
  late double scaleFactor;
  late int columns;
  late double cardBorderRadius;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreItemsFromInventory);

    horizontalSpacing = 12;
    verticalSpacing = 12;

    aspectRatio = 13 / 25;
    cardBorderRadius = 25;
  }

  @override
  Widget build(BuildContext context) {
    final res = context.res;

    columns = MediaQuery.of(context).size.width < 600 ? 2 : 4;

    /// Product Card Scale factor for X columns
    /// * 12 margin between columns
    /// * 0.008 scale factor from figma
    scaleFactor =
        ((MediaQuery.of(context).size.width - (12 * columns)) / columns) *
            0.008;

    return BlocBuilder<SearchInventoryBloc, SearchInventoryState>(
      builder: (context, state) {
        if (state is InventoryItemResults) {
          final inventoryProducts = state.results;

          if (state.isLoadingMore) {
            // Add loading more indicators
            inventoryProducts.addAll(
              List.generate(columns, (_) => ProductModel.loading()),
            );
          }

          return GridView.builder(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.only(
              right: res.dimens.spacingLarge,
              left: res.dimens.spacingLarge,
              top: res.dimens.spacingLarge,
              bottom: res.dimens.spacingLarge,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              childAspectRatio: aspectRatio,
              crossAxisSpacing: horizontalSpacing,
              mainAxisSpacing: verticalSpacing,
            ),
            itemBuilder: (BuildContext context, int index) {
              final productModel = inventoryProducts[index];

              if (productModel.status != ProductStatus.LOADING) {
                return ProductItemCard(
                  key: ValueKey('product_item$index'),
                  product: productModel,
                  scaleFactor: scaleFactor,
                  borderRadius: cardBorderRadius,
                );
              } else {
                return ProductItemCardLoading(borderRadius: cardBorderRadius);
              }
            },
            itemCount: inventoryProducts.length,
            controller: _scrollController,
          );
        } else if (state is SearchingForItemInInventory) {
          return ProductGridLoading(
            aspectRatio: aspectRatio,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing,
            scaleFactor: scaleFactor,
            columns: columns,
            borderRadius: cardBorderRadius,
          );
        } else if (state is ErrorOccurredSearchingForItem) {
          if (state.failure is NetworkError) {
            return DropezyError(
              title: res.strings.lostInternetConnection,
              message: res.strings.checkConnectionSettings,
            );
          } else {
            return DropezyError(
              title: res.strings.cantFindYourProduct,
              message: res.strings.searchForAnotherProduct,
            );
          }
        }

        return const SizedBox();
      },
    );
  }

  /// Checks if bottom of inventory list is reached
  ///
  /// * If end of inventory not reached and not already loading more,
  /// load more items from inventory.
  ///
  /// * Else skip loading more.
  void _loadMoreItemsFromInventory() {
    /// Load more items once bottom is almost reached
    final scrollOffset =
        _scrollController.position.maxScrollExtent - _scrollController.offset;

    if (scrollOffset < INVENTORY_SCROLL_OFFSET) {
      final inventoryBloc = context.read<SearchInventoryBloc>();

      // Only load more items if inventory end is not reached
      if (inventoryBloc.state is! InventoryItemResults) return;

      final currentState = inventoryBloc.state as InventoryItemResults;

      if (!currentState.isAtEnd && !currentState.isLoadingMore) {
        inventoryBloc.add(LoadMoreItems());
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
