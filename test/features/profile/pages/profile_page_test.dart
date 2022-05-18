import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/profile/index.dart';
import 'package:storefront_app/features/profile/widgets/widgets.dart';

import '../../../src/mock_navigator.dart';

void main() {
  late StackRouter stackRouter;

  setUp(() {
    stackRouter = MockStackRouter();

    // if not stubbed, this will throw an UnimplementedError when called
    // here, we stub it to do nothing because we're only checking for the
    // route name that's being pushed
    when(() => stackRouter.push(any())).thenAnswer((_) async => null);
  });

  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
  });

  group('[ProfilePage]', () {
    testWidgets(
      'should display Header, Account, and General section '
      'when page is loaded',
      (tester) async {
        final context = await tester.pumpProfilePage(stackRouter);

        expect(find.byType(ProfileHeader), findsOneWidget);
        expect(find.byType(ProfileAccountSection), findsOneWidget);
        expect(find.byType(ProfileGeneralSection), findsOneWidget);
        expect(find.text(context.res.strings.signOut), findsOneWidget);
      },
    );

    testWidgets(
      'should navigate to Edit Profile Page '
      'when edit icon is tapped',
      (tester) async {
        await tester.pumpProfilePage(stackRouter);

        await tester.tap(find.byKey(ProfilePageKeys.editProfileButton));
        await tester.pumpAndSettle();

        final capturedRoutes =
            verify(() => stackRouter.push(captureAny())).captured;

        // there should only be one route that's being pushed
        expect(capturedRoutes.length, 1);

        final routeInfo = capturedRoutes.first as PageRouteInfo;

        // expecting the right route being pushed
        expect(routeInfo, isA<EditProfileRoute>());
      },
    );

    group('ProfileAccountSection', () {
      testWidgets(
        'should display all correct menu tiles '
        'when page is rendered',
        (tester) async {
          final context = await tester.pumpProfilePage(stackRouter);

          expect(find.text(context.res.strings.myOrders), findsOneWidget);
          expect(find.text(context.res.strings.changeAddress), findsOneWidget);
          expect(find.text(context.res.strings.selectLanguage), findsOneWidget);
        },
      );

      testWidgets(
        'should navigate to Order Page '
        'when My Orders tile is tapped',
        (tester) async {
          final context = await tester.pumpProfilePage(stackRouter);

          await tester.tap(find.text(context.res.strings.myOrders));
          await tester.pumpAndSettle();

          final capturedRoutes =
              verify(() => stackRouter.push(captureAny())).captured;

          // there should only be one route that's being pushed
          expect(capturedRoutes.length, 1);

          final routeInfo = capturedRoutes.first as PageRouteInfo;

          // expecting the right route being pushed
          expect(routeInfo, isA<OrderRouter>());
        },
      );

      testWidgets(
        'should navigate to Change Address Page '
        'when Change Address tile is tapped',
        (tester) async {
          final context = await tester.pumpProfilePage(stackRouter);

          await tester.tap(find.text(context.res.strings.changeAddress));
          await tester.pumpAndSettle();

          final capturedRoutes =
              verify(() => stackRouter.push(captureAny())).captured;

          // there should only be one route that's being pushed
          expect(capturedRoutes.length, 1);

          final routeInfo = capturedRoutes.first as PageRouteInfo;

          // expecting the right route being pushed
          expect(routeInfo, isA<ChangeAddressRoute>());
        },
      );
    });

    group('ProfileGeneralSection', () {
      testWidgets(
        'should display all correct menu tiles '
        'when page is rendered',
        (tester) async {
          final context = await tester.pumpProfilePage(stackRouter);

          expect(find.text(context.res.strings.privacyPolicy), findsOneWidget);
          expect(find.text(context.res.strings.help), findsOneWidget);
          expect(find.text(context.res.strings.termsOfUse), findsOneWidget);
          expect(find.text(context.res.strings.howItWorks), findsOneWidget);
          expect(find.text(context.res.strings.aboutUs), findsOneWidget);
        },
      );
    });
  });
}

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpProfilePage(StackRouter stackRouter) async {
    late BuildContext ctx;

    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return StackRouterScope(
              controller: stackRouter,
              stateHash: 0,
              child: const Scaffold(
                body: ProfilePage(),
              ),
            );
          },
        ),
      ),
    );

    return ctx;
  }
}
