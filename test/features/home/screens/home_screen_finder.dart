import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/home/screens/home_page.dart';

class HomeScreenFinders {
  static Finder get loadingCategoryOneWidget =>
      find.byKey(const ValueKey(HomePageKeys.loadingCategoryOneWidget));

  static Finder get gridCategoryOneWidget =>
      find.byKey(const ValueKey(HomePageKeys.categoryOneListWidget));

  static Finder get errorCategoryOneWidget =>
      find.byKey(const ValueKey(HomePageKeys.errorCategoryOneWidget));
}
