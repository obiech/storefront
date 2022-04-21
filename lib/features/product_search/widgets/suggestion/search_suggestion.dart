import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';
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
              horizontal: res.dimens.spacingLarge,
              vertical: res.dimens.spacingLarge,
            ),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return SearchSuggestionItem(
                  key: ValueKey(
                    '${SearchSuggestionKeys.searchSuggestionItemKey}_${state.suggestions[index]}',
                  ),
                  query: state.suggestions[index],
                  onSelect: (query) {
                    onItemTapped?.call();
                    context.read<SearchInventoryCubit>().searchInventory(query);
                    context.read<AutosuggestionBloc>().add(ResetSuggestions());
                    context.read<SearchHistoryCubit>().addSearchQuery(query);
                  },
                );
              },
              itemCount: state.suggestions.length,
              shrinkWrap: true,
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
