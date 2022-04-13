import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/home/screens/home_page.dart';

class HomeScreenFinders {
  static Finder get loadingParentCategoryWidget =>
      find.byKey(const ValueKey(HomePageKeys.loadingparentCategoryWidget));

  static Finder get gridParentCategoryWidget =>
      find.byKey(const ValueKey(HomePageKeys.parentCategoryGridWidget));

  static Finder get errorParentCategoryWidget =>
      find.byKey(const ValueKey(HomePageKeys.errorParentCategoryWidget));
}
