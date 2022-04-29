import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';

import '../../index.dart';

part 'keys.dart';
part 'search_history_item.dart';

/// Display's previous search parameters
/// for quick access
class SearchHistory extends StatelessWidget {
  final Function()? onItemTapped;

  const SearchHistory({Key? key, this.onItemTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return BlocBuilder<SearchHistoryCubit, SearchHistoryState>(
      builder: (context, state) {
        if (state is LoadedSearchQueries && state.queries.isNotEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: res.dimens.spacingLarge,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        res.strings.youPreviouslySearchedFor,
                        style: res.styles.caption1
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextButton.icon(
                      onPressed:
                          context.read<SearchHistoryCubit>().clearSearchQueries,
                      label: Text(
                        res.strings.clearAll,
                        style: res.styles.caption2.copyWith(
                          fontWeight: FontWeight.w600,
                          color: res.colors.blue,
                        ),
                      ),
                      icon: Icon(
                        DropezyIcons.trash,
                        size: 16,
                        color: res.colors.blue,
                      ),
                    )
                  ],
                ),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return SearchHistoryItem(
                      key: ValueKey(
                        '${SearchHistoryKeys.searchHistoryItemKey}_${state.queries[index]}',
                      ),
                      query: state.queries[index],
                      onDelete:
                          context.read<SearchHistoryCubit>().removeSearchQuery,
                      onSelect: (query) {
                        context
                            .read<SearchInventoryBloc>()
                            .add(SearchInventory(query));

                        onItemTapped?.call();
                      },
                    );
                  },
                  itemCount: state.queries.length,
                  shrinkWrap: true,
                )
              ],
            ),
          );
        }
        return const DefaultSearchPage();
      },
    );
  }
}
