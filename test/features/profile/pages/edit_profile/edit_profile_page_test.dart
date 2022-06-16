import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/profile/index.dart';

import '../../../../../test_commons/fixtures/profile/profile_model.dart';
import '../../../../commons.dart';
import '../../../../src/mock_navigator.dart';
import '../../mocks.dart';

void main() {
  late StackRouter stackRouter;
  late EditProfileBloc editProfileBloc;
  late ProfileCubit profileCubit;

  const fullName = 'dummyName';

  setUp(() {
    stackRouter = MockStackRouter();
    editProfileBloc = MockEditProfileBloc();
    profileCubit = MockProfileCubit();

    // Default state
    when(() => editProfileBloc.state).thenReturn(const EditProfileState());
    when(() => profileCubit.state).thenReturn(const ProfileLoaded(mockProfile));

    when(() => stackRouter.pop(any())).thenAnswer((_) async => false);
  });

  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
    setUpLocaleInjection();
  });

  testWidgets(
    'should display view correctly '
    'when page is rendered',
    (widgetTester) async {
      await widgetTester.pumpEditProfilePage(
        stackRouter,
        editProfileBloc,
        profileCubit,
      );

      expect(
        find.byKey(EditProfilePageKeys.fullNameField),
        findsOneWidget,
      );
      expect(
        find.byKey(EditProfilePageKeys.saveProfileButton),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should show validation error '
    'when save button is tapped '
    'and form is empty',
    (widgetTester) async {
      final context = await widgetTester.pumpEditProfilePage(
        stackRouter,
        editProfileBloc,
        profileCubit,
      );

      await widgetTester.tap(find.byKey(EditProfilePageKeys.saveProfileButton));
      await widgetTester.pumpAndSettle();

      expect(
        find.text(
          context.res.strings.cannotBeEmpty(context.res.strings.name()),
        ),
        findsOneWidget,
      );
    },
  );
  testWidgets(
    'should display snack bar '
    'when save button is tapped '
    'and form is filled '
    'and error occurred',
    (widgetTester) async {
      whenListen(
        editProfileBloc,
        Stream.fromIterable([
          const EditProfileState(errorMessage: 'Error!'),
        ]),
      );

      await widgetTester.pumpEditProfilePage(
        stackRouter,
        editProfileBloc,
        profileCubit,
      );

      await widgetTester.enterText(
        find.byKey(EditProfilePageKeys.fullNameField),
        fullName,
      );

      await widgetTester.tap(find.byKey(EditProfilePageKeys.saveProfileButton));
      await widgetTester.pumpAndSettle();

      verify(() => editProfileBloc.add(const FormSubmitted())).called(1);

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text('Error!'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should call [ProfileCubit] refreshUpdatedName '
    'and back to previous route '
    'and display snack bar '
    'when save button is tapped '
    'and form is filled '
    'and success is occurred',
    (widgetTester) async {
      whenListen(
        editProfileBloc,
        Stream.fromIterable([
          const EditProfileState(
            profileUpdated: true,
            fullName: fullName,
          ),
        ]),
      );

      await widgetTester.pumpEditProfilePage(
        stackRouter,
        editProfileBloc,
        profileCubit,
      );

      await widgetTester.enterText(
        find.byKey(EditProfilePageKeys.fullNameField),
        fullName,
      );

      await widgetTester.tap(find.byKey(EditProfilePageKeys.saveProfileButton));
      await widgetTester.pumpAndSettle();

      verify(() => editProfileBloc.add(const FormSubmitted())).called(1);
      verify(() => profileCubit.refreshUpdatedName(fullName)).called(1);
      verify(() => stackRouter.pop()).called(1);
    },
  );
}

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpEditProfilePage(
    StackRouter stackRouter,
    EditProfileBloc editProfileBloc,
    ProfileCubit profileCubit,
  ) async {
    late BuildContext ctx;

    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return StackRouterScope(
              controller: stackRouter,
              stateHash: 0,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => editProfileBloc,
                  ),
                  BlocProvider(
                    create: (context) => profileCubit,
                  ),
                ],
                child: const Scaffold(
                  body: EditProfilePage(),
                ),
              ),
            );
          },
        ),
      ),
    );

    return ctx;
  }
}
