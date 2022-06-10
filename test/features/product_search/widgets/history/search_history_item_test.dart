import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/dropezy_icons.dart';
import 'package:storefront_app/features/product_search/index.dart';

import '../../../../commons.dart';

extension WidgetX on WidgetTester {
  Future<void> pumpSearchHistoryItem(
    String query, {
    Function(String)? onDelete,
    Function(String)? onSelect,
  }) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchHistoryItem(
            query: query,
            onDelete: onDelete,
            onSelect: onSelect,
          ),
        ),
      ),
    );
  }
}

void main() {
  setUpAll(() {
    setUpLocaleInjection();
  });

  testWidgets('should show provided query', (WidgetTester tester) async {
    /// arrange
    const query = 'tomatoes';

    /// act
    await tester.pumpSearchHistoryItem(query);

    /// assert
    expect(find.text(query), findsOneWidget);
  });

  testWidgets('should select provided query when tapped',
      (WidgetTester tester) async {
    /// arrange
    const query = 'tomatoes';
    var isSelected = false;
    var selectedQuery = '';

    /// act
    await tester.pumpSearchHistoryItem(
      query,
      onSelect: (val) {
        selectedQuery = val;
        isSelected = true;
      },
    );

    /// assert
    expect(find.byType(Row), findsOneWidget);
    await tester.tap(find.byType(Row));

    expect(isSelected, true);
    expect(selectedQuery, query);
  });

  testWidgets('should delete provided query when delete is tapped',
      (WidgetTester tester) async {
    /// arrange
    const query = 'tomatoes';
    var isDeleted = false;
    var deletedQuery = '';

    /// act
    await tester.pumpSearchHistoryItem(
      query,
      onDelete: (val) {
        deletedQuery = val;
        isDeleted = true;
      },
    );

    /// assert
    final deleteButtonFinder = find.byIcon(DropezyIcons.cross);
    expect(deleteButtonFinder, findsOneWidget);
    await tester.tap(deleteButtonFinder);

    expect(isDeleted, true);
    expect(deletedQuery, query);
  });
}
