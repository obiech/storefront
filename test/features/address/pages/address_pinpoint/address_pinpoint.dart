import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/address/index.dart';

const cameraTarget = LatLng(0, 0);

void main() {
  testWidgets(
    'should display view correctly '
    'when page is rendered',
    (tester) async {
      await tester.pumpAddressPinpointPage();

      expect(
        find.byKey(AddressPinPointPageKeys.marker),
        findsOneWidget,
      );

      expect(find.byType(PanToCurrentLocationIcon), findsOneWidget);

      expect(
        find.byKey(AddressPinPointPageKeys.panToCurrentLocationIcon),
        findsOneWidget,
      );

      expect(
        find.byKey(AddressPinPointPageKeys.googleMapView),
        findsOneWidget,
      );

      expect(
        find.byKey(AddressPinPointPageKeys.confirmAddress),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should retrieve user current location '
    'when currentLocation widget is tapped',
    (tester) async {
      await tester.pumpAddressPinpointPage();

      await tester
          .tap(find.byKey(AddressPinPointPageKeys.panToCurrentLocationIcon));
      await tester.pumpAndSettle();

      verify(() => getCurrentLocation(any())).called(1);
    },
  );
}

extension WidgetTesterX on WidgetTester {
  Future pumpAddressPinpointPage() async {
    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return const Scaffold(
              body: AddressPinpointPage(cameraTarget: cameraTarget),
            );
          },
        ),
      ),
    );
  }
}
