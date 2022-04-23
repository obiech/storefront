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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: res.colors.white,
          boxShadow: [
            BoxShadow(
              color: res.colors.white,
              offset: const Offset(1, 1),
              blurRadius: 2,
              spreadRadius: .5,
            ),
            BoxShadow(
              color: res.colors.grey3,
              offset: const Offset(-.5, -.5),
              blurRadius: 2,
              spreadRadius: .5,
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Text(
          query,
          style: res.styles.caption3.copyWith(
            fontWeight: FontWeight.w500,
            color: res.colors.grey5,
          ),
        ),
      ),
    );
  }
}
