part of 'search_history.dart';

class SearchHistoryItem extends StatelessWidget {
  /// The search query
  final String query;

  /// Callback to delete history item
  final Function(String)? onDelete;

  /// Callback to search using query
  final Function(String)? onSelect;

  const SearchHistoryItem({
    Key? key,
    required this.query,
    this.onDelete,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return InkWell(
      onTap: () => onSelect?.call(query),
      child: Row(
        children: [
          Icon(
            DropezyIcons.history,
            color: res.colors.grey4,
            size: 16,
          ),
          const SizedBox(
            width: 5,
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
          IconButton(
            onPressed: () => onDelete?.call(query),
            color: res.colors.grey4,
            iconSize: 16,
            icon: const Icon(DropezyIcons.cross),
          )
        ],
      ),
    );
  }
}
