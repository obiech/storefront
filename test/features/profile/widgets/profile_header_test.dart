import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/profile/index.dart';
import 'package:storefront_app/features/profile/widgets/profile_header.dart';

import '../../../../test_commons/fixtures/profile/profile_model.dart';
import '../../../commons.dart';
import '../mocks.dart';

void main() {
  setUpAll(() {
    setUpLocaleInjection();
  });

  group('ProfileHeader', () {
    late ProfileCubit profileCubit;

    setUp(() {
      profileCubit = MockProfileCubit();
    });

    testWidgets(
      'should display phone number and edit profile button '
      'when profile is loaded '
      'and name is not set',
      (tester) async {
        when(() => profileCubit.state).thenReturn(
          ProfileLoaded(mockProfile.copyWith(fullName: '')),
        );

        await tester.pumpWidget(
          BlocProvider.value(
            value: profileCubit,
            child: const MaterialApp(
              home: Material(
                child: ProfileHeader(),
              ),
            ),
          ),
        );

        expect(find.byKey(ProfilePageKeys.userName), findsNothing);
        expect(find.byKey(ProfilePageKeys.userPhoneNumber), findsOneWidget);
        expect(find.byKey(ProfilePageKeys.editProfileButton), findsOneWidget);
      },
    );

    testWidgets(
      'should display name, phone number, and edit profile button '
      'when profile is loaded '
      'and name is set',
      (tester) async {
        when(() => profileCubit.state).thenReturn(
          const ProfileLoaded(mockProfile),
        );

        await tester.pumpWidget(
          BlocProvider.value(
            value: profileCubit,
            child: const MaterialApp(
              home: Material(
                child: ProfileHeader(),
              ),
            ),
          ),
        );

        expect(find.byKey(ProfilePageKeys.userName), findsOneWidget);
        expect(find.byKey(ProfilePageKeys.userPhoneNumber), findsOneWidget);
        expect(find.byKey(ProfilePageKeys.editProfileButton), findsOneWidget);
      },
    );
  });
}
