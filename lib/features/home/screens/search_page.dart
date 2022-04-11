import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

/// TODO - Refactor to own feature
class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return DropezyScaffold.textTitle(
      title: 'Search',
      child: Text(
        'Search',
        style: res.styles.title,
      ),
    );
  }
}
