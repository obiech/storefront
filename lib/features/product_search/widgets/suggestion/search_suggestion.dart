import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';

import '../../index.dart';

part 'keys.dart';
part 'search_suggestion_item.dart';
part 'search_suggestion_loading.dart';

/// Display's previous search parameters
/// for quick access
class SearchSuggestion extends StatelessWidget {
  final Function()? onItemTapped;

  const SearchSuggestion({Key? key, this.onItemTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return BlocBuilder<AutosuggestionBloc, AutosuggestionState>(
      builder: (context, state) {
        if (state is LoadedAutosuggestions && state.suggestions.isNotEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: res.dimens.spacingLarge,
            ),
            child: Wrap(
              spacing: res.dimens.spacingMedium,
              runSpacing: res.dimens.spacingMedium,
              children: [
                for (final suggestion in state.suggestions)
                  SearchSuggestionItem(
                    key: ValueKey(
                      '${SearchSuggestionKeys.searchSuggestionItemKey}_$suggestion',
                    ),
                    query: suggestion,
                    onSelect: (query) {
                      onItemTapped?.call();
                      context
                          .read<SearchInventoryCubit>()
                          .searchInventory(query);
                      context
                          .read<AutosuggestionBloc>()
                          .add(ResetSuggestions());
                      context.read<SearchHistoryCubit>().addSearchQuery(query);
                    },
                  )
              ],
            ),
          );
        } else if (state is GettingAutosuggestions) {
          return const SearchSuggestionLoading();
        }

        return const SizedBox();
      },
    );
  }
}
