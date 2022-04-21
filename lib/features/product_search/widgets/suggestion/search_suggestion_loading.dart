part of 'search_suggestion.dart';

class SearchSuggestionLoading extends StatelessWidget {
  const SearchSuggestionLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: res.dimens.spacingLarge,
        vertical: res.dimens.spacingLarge,
      ),
      child: SkeletonParagraph(
        style: SkeletonParagraphStyle(
          lines: 5,
          spacing: 15,
          lineStyle: SkeletonLineStyle(
            randomLength: false,
            height: 15,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
