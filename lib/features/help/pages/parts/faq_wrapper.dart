part of '../help_page.dart';

/// A wrapper class around [DropezyExpansionTile] used to reduce boilerPlate code
/// when creating FAQ widget.
class _FAQWrapper extends StatelessWidget {
  const _FAQWrapper(
    this.questionAndAnswer, {
    Key? key,
  }) : super(key: key);

  final QuestionAndAnswer questionAndAnswer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.res.dimens.pagePadding,
      ),
      child: DropezyExpansionTile.textSubtitle(
        title: questionAndAnswer.question,
        subtitle: questionAndAnswer.answer,
      ),
    );
  }
}
