import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/screens/request_location/request_location_access_page.dart';

import '../../../../../test_commons/finders/address/request_location_access_page_finders.dart';
import '../../../../src/mock_navigator.dart';

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpRequestLocationAccessPage({
    required StackRouter router,
  }) async {
    late BuildContext ctx;
    await pumpWidget(
      StackRouterScope(
        controller: router,
        stateHash: 0,
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              ctx = context;
              return const RequestLocationAccessPage();
            },
          ),
        ),
      ),
    );

    return ctx;
  }
}

void main() {
  group(
    '[RequestLocationAccessPage]',
    () {
      late StackRouter router;

      setUp(() {
        router = MockStackRouter();
        registerFallbackValue(FakePageRouteInfo());
        when(() => router.push(any())).thenAnswer((_) async => null);
        when(() => router.replace(any())).thenAnswer((_) async => null);
      });

      testWidgets(
        'should display an asset image and rationale for requesting '
        'location access permission',
        (tester) async {
          final ctx = await tester.pumpRequestLocationAccessPage(
            router: router,
          );

          // should find a SVG image
          final SvgPicture assetImage = tester.firstWidget(
            RequestLocationAccessPageFinders.assetImage,
          ) as SvgPicture;

          expect(assetImage.pictureProvider, isA<ExactAssetPicture>());
          expect(
            (assetImage.pictureProvider as ExactAssetPicture).assetName,
            ctx.res.paths.imageLocationAccess,
          );

          // should display rationale
          expect(
            find.text(ctx.res.strings.locationAccessRationale),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'should display an option for user to grant location access',
        (tester) async {
          final ctx = await tester.pumpRequestLocationAccessPage(
            router: router,
          );

          // should find a button that says 'Grant Access'
          final DropezyButton button = tester.firstWidget<DropezyButton>(
            RequestLocationAccessPageFinders.buttonGrantAccess,
          );

          expect(button.label, ctx.res.strings.activateNow);
        },
      );

      testWidgets(
        'should display an option for user to skip this process '
        'that takes them directly to Search Location page',
        (tester) async {
          final ctx = await tester.pumpRequestLocationAccessPage(
            router: router,
          );

          // should find a button that says 'Grant Access'
          final TextButton button = tester.firstWidget<TextButton>(
            RequestLocationAccessPageFinders.buttonSkipProcess,
          );

          expect((button.child! as Text).data, ctx.res.strings.later);

          await tester.ensureVisible(
            RequestLocationAccessPageFinders.buttonSkipProcess,
          );
          await tester.tap(RequestLocationAccessPageFinders.buttonSkipProcess);

          final result = verify(() => router.replace(captureAny())).captured;

          expect(result.length, 1);
          expect(result.first as PageRouteInfo, isA<SearchLocationRoute>());
        },
      );
    },
  );
}
