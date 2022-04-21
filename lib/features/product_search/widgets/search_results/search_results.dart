import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product_search/widgets/search_results/search_results_loading.dart';

import '../../index.dart';

class SearchResults extends StatefulWidget {
  const SearchResults({Key? key}) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        context.read<SearchInventoryCubit>().loadMoreItems();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final res = context.res;

    return BlocConsumer<SearchInventoryCubit, SearchInventoryState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is InventoryItemResults) {
          return GridView.builder(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: res.dimens.spacingLarge,
              vertical: res.dimens.spacingLarge,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 3
                      : 4,
              childAspectRatio: 13 / 25,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (BuildContext context, int index) {
              return ProductItemCard(
                key: ValueKey('product_item$index'),
                product: state.results[index],
              );
            },
            shrinkWrap: true,
            itemCount: state.results.length,
          );
        } else if (state is SearchingForItemInInventory) {
          return const SearchResultsLoading();
        }

        return const SizedBox();
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
