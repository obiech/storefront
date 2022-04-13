import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/child_categories/index.dart';

class ChildCategoryFinders {
  static Finder get listChildCategoryWidget =>
      find.byKey(const ValueKey(ChildCategoryKeys.childCategoryListWidget));
}
