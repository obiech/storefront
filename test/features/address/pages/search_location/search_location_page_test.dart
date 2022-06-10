import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/address/index.dart';

import '../../../../../test_commons/fixtures/address/places_auto_complete_result.dart';
import '../../../../commons.dart';
import '../../mocks.dart';

void main() {
  late SearchLocationBloc searchLocationBloc;

  setUp(() {
    searchLocationBloc = MockSearchLocationBloc();

    // default state
    when(() => searchLocationBloc.state)
        .thenReturn(const SearchLocationInitial());
  });

  setUpAll(() {
    setUpLocaleInjection();
  });

  testWidgets(
    'should display view correctly '
    'when page is rendered',
    (tester) async {
      await tester.pumpSearchLocationPage(searchLocationBloc);

      expect(find.byType(SearchLocationHeader), findsOneWidget);
      expect(find.byType(SearchLocationResult), findsOneWidget);
    },
  );

  testWidgets(
    'should display list of places '
    'when state is loaded',
    (tester) async {
      when(() => searchLocationBloc.state)
          .thenReturn(SearchLocationLoaded(placesResultList));

      await tester.pumpSearchLocationPage(searchLocationBloc);

      expect(find.byType(SearchLocationHeader), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(
        find.byType(PlaceSuggestionTile),
        findsNWidgets(placesResultList.length),
      );
    },
  );
}

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpSearchLocationPage(
    SearchLocationBloc bloc,
  ) async {
    late BuildContext ctx;

    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return Scaffold(
              body: BlocProvider.value(
                value: bloc,
                child: const SearchLocationPage(),
              ),
            );
          },
        ),
      ),
    );

    return ctx;
  }
}
