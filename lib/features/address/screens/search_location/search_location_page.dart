import 'package:flutter/material.dart';

import '../../../../../core/core.dart';

class SearchLocationPage extends StatelessWidget {
  const SearchLocationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: context.res.strings.whereIsYourAddress,
      child: const Center(
        child: Text('Search Location Placeholder'),
      ),
    );
  }
}
