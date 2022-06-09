import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';

class ProductWidgetFinders {
  static final incrementButtonFinder = find.ancestor(
    of: find.byIcon(DropezyIcons.plus),
    matching: find.byType(RawMaterialButton),
  );

  static final decrementButtonFinder = find.ancestor(
    of: find.byIcon(DropezyIcons.minus),
    matching: find.byType(RawMaterialButton),
  );
}
