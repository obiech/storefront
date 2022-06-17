import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/features/address/index.dart';

class SearchLocationHistoryList extends StatelessWidget {
  const SearchLocationHistoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchLocationHistoryBloc, SearchLocationHistoryState>(
      builder: (context, state) {
        if (state is SearchLocationHistoryLoaded) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final searchHistory = state.placeList[index];

              return PlaceSuggestionTile.history(
                place: searchHistory.toPlacesService(),
                onTap: () {
                  context
                      .read<SearchLocationBloc>()
                      .add(LocationSelected(searchHistory.placeId));
                },
              );
            },
            itemCount: state.placeList.length,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
