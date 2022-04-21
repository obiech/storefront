part of 'search_suggestion.dart';

class SearchSuggestionItem extends StatelessWidget {
  /// The search query
  final String query;

  /// Callback to search using query
  final Function(String)? onSelect;

  const SearchSuggestionItem({
    Key? key,
    required this.query,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return InkWell(
      onTap: () => onSelect?.call(query),
      child: Row(
        children: [
          SizedBox(
            width: 5,
            height: res.dimens.spacingMxlarge,
          ),
          Expanded(
            child: Text(
              query,
              style: res.styles.caption1.copyWith(
                fontWeight: FontWeight.w500,
                color: res.colors.grey5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
