import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

import '../index.dart';

/// Home search widget that connects to search page
class SearchHeader extends StatelessWidget {
  const SearchHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return Container(
      padding: EdgeInsets.all(res.dimens.spacingMlarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            res.strings.hiWhatAreYouShoppingForToday(
              //TODO(Jeco): Pass name and handle profile state
              '',
            ),
            style: res.styles.button.copyWith(
              fontSize: 22,
              height: 34 / 22,
            ),
          ),
          SizedBox(
            height: res.dimens.spacingLarge,
          ),
          TextField(
            readOnly: true,
            decoration: res.styles.roundedInputStyle.copyWith(
              hintText: res.strings.findYourNeeds,
              contentPadding: EdgeInsets.symmetric(
                vertical: res.dimens.spacingMiddle,
                horizontal: 5,
              ),
              prefixIcon: Icon(
                DropezyIcons.search_alt,
                size: 18,
                color: res.colors.grey4,
              ),
            ),
            style: res.styles.caption1,
            onTap: () => AutoTabsRouter.of(context)
                .setActiveIndex(BottomNav.SEARCH.index),
          ),
        ],
      ),
    );
  }
}
