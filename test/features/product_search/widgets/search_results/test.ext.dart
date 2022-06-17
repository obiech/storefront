import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/product_search/index.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpSearchResultsWidget(
    SearchInventoryBloc searchBloc,
  ) async {
    await pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => searchBloc,
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SearchResults(),
          ),
        ),
      ),
    );
  }
}
