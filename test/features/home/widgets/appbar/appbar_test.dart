import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';
import 'package:storefront_app/features/auth/domain/repository/user_credentials.dart';
import 'package:storefront_app/features/auth/widgets/auth_bottom_sheet.dart';
import 'package:storefront_app/features/home/widgets/appbar/appbar.dart';

import '../../mocks.dart';

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpHomeAppBar({
    required Stream<UserCredentials?> stream,
  }) async {
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
              child: Scaffold(
                appBar: HomeAppBar(
                  userCredentialsStream: stream,
                ),
                body: const Center(),
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
  group(
    '[HomeAppBar]',
    () {
      testWidgets(
        'should display dropezy logo and notifications icon button at all time',
        (tester) async {
          final ctx = await tester.pumpHomeAppBar(
            stream: Stream.fromIterable([]),
          );

          // should find a Dropezy 'D' Logo
          final assetImage = tester.firstWidget<SvgPicture>(
            find.byKey(const Key(HomeAppBarKeys.dropezyLogo)),
          );

          expect(assetImage.pictureProvider, isA<ExactAssetPicture>());
          expect(
            (assetImage.pictureProvider as ExactAssetPicture).assetName,
            ctx.res.paths.imageDropezyLogo,
          );

          // should find notification icon
          final notificationButton = tester.firstWidget<IconButton>(
            find.byKey(const Key(HomeAppBarKeys.buttonNotifications)),
          );

          expect((notificationButton.icon as Icon).icon, DropezyIcons.bell);
        },
      );

      testWidgets(
        'should display a prompt to login or register or address selection '
        'based on whether or not user is logged in',
        (tester) async {
          final streamCtrl = StreamController<UserCredentials?>();

          final ctx = await tester.pumpHomeAppBar(stream: streamCtrl.stream);

          // Should show Login or Register prompt if user is logged out
          streamCtrl.add(null);
          await tester.pumpAndSettle();
          expect(find.byType(PromptLoginOrRegister), findsOneWidget);
          expect(find.byType(AddressSelection), findsNothing);

          // Should show Address Selection and Delivery Duration widget
          // if user is logged in
          streamCtrl.add(
            const UserCredentials(
              authToken: 'acdef',
              phoneNumber: '+628123123123',
            ),
          );
          await tester.pumpAndSettle();
          expect(find.byType(PromptLoginOrRegister), findsNothing);
          expect(find.byType(AddressSelection), findsOneWidget);

          // TODO (leovinsen): update with proper logic from geofence service
          final deliveryDurationChip =
              tester.widget<DropezyChip>(find.byType(DropezyChip));

          expect(deliveryDurationChip.label, ctx.res.strings.minutes(15));

          // Should show Login or Register prompt if user is logged out
          streamCtrl.add(null);
          await tester.pumpAndSettle();
          expect(find.byType(PromptLoginOrRegister), findsOneWidget);
          expect(find.byType(AddressSelection), findsNothing);
        },
      );

      testWidgets(
        'should open AuthBottomSheet '
        'when user is not logged in '
        'and prompt is pressed',
        (tester) async {
          final streamCtrl = StreamController<UserCredentials?>();
          await tester.pumpHomeAppBar(stream: streamCtrl.stream);

          // user not logged in
          streamCtrl.add(null);
          await tester.pumpAndSettle();
          expect(find.byType(PromptLoginOrRegister), findsOneWidget);

          await tester.tap(find.byType(PromptLoginOrRegister));
          await tester.pumpAndSettle();

          expect(find.byType(AuthBottomSheet), findsOneWidget);
        },
      );
    },
  );
}
