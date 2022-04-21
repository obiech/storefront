import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

/// When there is no search history & no inventory
/// show default page
class DefaultSearchPage extends StatelessWidget {
  const DefaultSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 2 - 100,
        ),
        Text(res.strings.searchForWhatYouNeed)
      ],
    );
  }
}
