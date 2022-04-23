import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/product_search/index.dart';

import '../../fixtures.dart';
import '../../mocks.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpSearchSuggestionWidget(AutosuggestionBloc bloc) async {
    await pumpWidget(
      BlocProvider(
        create: (context) => bloc,
        child: const MaterialApp(
          home: Scaffold(
            body: SearchSuggestion(),
          ),
        ),
      ),
    );
  }
}

void main() {
  late AutosuggestionBloc bloc;
  late IProductSearchRepository repository;

  setUp(() {
    repository = MockProductSearchRepository();
    bloc = AutosuggestionBloc(repository);
  });

  testWidgets('When loading, a shimmer is shown', (WidgetTester tester) async {
    bloc.emit(GettingAutosuggestions());
    await tester.pumpSearchSuggestionWidget(bloc);

    for (int i = 0; i < 5; i++) {
      await tester.pump();
    }

    expect(find.byType(SearchSuggestionLoading), findsOneWidget);
  });

  testWidgets('When no state is available nothing is shown',
      (WidgetTester tester) async {
    bloc.emit(AutoSuggestionInitial());
    await tester.pumpSearchSuggestionWidget(bloc);

    expect(find.byType(SizedBox), findsNWidgets(1));
  });

  testWidgets('When suggestion are available, show suggestions list',
      (WidgetTester tester) async {
    bloc.emit(const LoadedAutosuggestions(autosuggestions));
    await tester.pumpSearchSuggestionWidget(bloc);

    expect(find.byType(Wrap), findsOneWidget);

    final _suggestionWidgets =
        tester.widgetList(find.byType(SearchSuggestionItem));

    expect(_suggestionWidgets.length, autosuggestions.length);
  });
}
