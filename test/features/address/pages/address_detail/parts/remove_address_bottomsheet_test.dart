import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';

import '../../../../../commons.dart';
import '../../../../../src/mock_navigator.dart';

void main() {
  late StackRouter router;

  setUp(() {
    router = MockStackRouter();

    when(() => router.pop(any())).thenAnswer((_) async => false);
  });

  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
    setUpLocaleInjection();
  });

  group('[RemoveAddressBottomSheet]', () {
    testWidgets('should close when cancel button is tapped', (tester) async {
      final context = await tester.pumpRemoveAddressSheet(router);

      expect(find.byType(RemoveAddressBottomSheet), findsOneWidget);

      await tester.tap(find.text(context.res.strings.cancel));
      await tester.pumpAndSettle();

      expect(find.byType(RemoveAddressBottomSheet), findsNothing);
    });
  });

  testWidgets(
      'should close current page '
      "when 'Remove' button is tapped", (tester) async {
    final context = await tester.pumpRemoveAddressSheet(router);

    await tester.tap(find.text(context.res.strings.remove));
    await tester.pump(const Duration(seconds: 1));

    verify(() => router.pop(captureAny())).called(1);
  });
}

/// Helper functions specific to this test
extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpRemoveAddressSheet(StackRouter stackRouter) async {
    late BuildContext ctx;

    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return const RemoveAddressBottomSheet();
          },
        ),
      ).withRouterScope(stackRouter),
    );

    return ctx;
  }
}
