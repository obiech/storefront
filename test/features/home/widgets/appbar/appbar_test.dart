import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';
import 'package:storefront_app/features/home/widgets/address_selection_bottom_sheet/address_selection_bottom_sheet.dart';
import 'package:storefront_app/features/home/widgets/appbar/appbar.dart';

import '../../../../../test_commons/utils/locale_setup.dart';
import '../../mocks.dart';

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpHomeAppBar() async {
    late BuildContext ctx;

    // Mock dependency of Address Selection
    final cubit = MockDeliveryAddressCubit();
    when(() => cubit.state).thenReturn(const DeliveryAddressInitial());
    whenListen(cubit, Stream.fromIterable([const DeliveryAddressInitial()]));
    when(() => cubit.close()).thenAnswer((_) async {});

    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return BlocProvider<DeliveryAddressCubit>(
              create: (_) => cubit,
              child: const Scaffold(
                appBar: HomeAppBar(),
                body: Center(),
              ),
            );
          },
        ),
      ),
    );

    return ctx;
  }
}

void main() {
  setUpAll(() {
    setUpLocaleInjection();
  });

  group(
    '[HomeAppBar]',
    () {
      testWidgets(
        'should display dropezy logo, '
        'address selection and its delivery estimation ',
        (tester) async {
          // act
          final ctx = await tester.pumpHomeAppBar();

          // assert
          // should find a Dropezy 'D' Logo
          final assetImage = tester.firstWidget<SvgPicture>(
            find.byKey(const Key(HomeAppBarKeys.dropezyLogo)),
          );
          expect(assetImage.pictureProvider, isA<ExactAssetPicture>());
          expect(
            (assetImage.pictureProvider as ExactAssetPicture).assetName,
            ctx.res.paths.imageDropezyLogo,
          );

          expect(find.byType(AddressSelection), findsOneWidget);

          // TODO (leovinsen): update with proper logic from geofence service
          final deliveryDurationChip =
              tester.widget<DropezyChip>(find.byType(DropezyChip));

          expect(deliveryDurationChip.label, ctx.res.strings.minutes(15));

          // should find notification icon
          // TODO: Re-enable once notifications feature is available
          // final notificationButton = tester.firstWidget<IconButton>(
          //   find.byKey(const Key(HomeAppBarKeys.buttonNotifications)),
          // );

          // expect((notificationButton.icon as Icon).icon, DropezyIcons.bell);
        },
      );

      testWidgets(
        'should open AddressSelectionBottomSheet '
        'when address selection is tapped',
        (tester) async {
          // act
          await tester.pumpHomeAppBar();

          // assert
          expect(find.byType(AddressSelection), findsOneWidget);
          await tester.tap(find.byType(AddressSelection));
          await tester.pumpAndSettle();

          expect(find.byType(AddressSelectionBottomSheet), findsOneWidget);
        },
      );
    },
  );
}
