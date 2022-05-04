part of 'search_suggestion.dart';

class SearchSuggestionLoading extends StatelessWidget {
  const SearchSuggestionLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: res.dimens.spacingLarge,
        horizontal: res.dimens.spacingLarge,
      ),
      child: Wrap(
        spacing: res.dimens.spacingMedium,
        runSpacing: res.dimens.spacingMedium,
        children: [
          for (int i = 0; i < 3; i++)
            LoadingItem(
              height: 35,
              width: randomBetween(50, 100).toDouble(),
              borderRadius: 8,
            )
        ],
      ),
    );
  }
}
