import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/profile/blocs/profile_cubit.dart';
import 'package:storefront_app/features/profile/index.dart';
import 'package:storefront_app/features/profile/widgets/profile_header.dart';

import '../mocks.dart';

void main() {
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
          const ProfileLoaded(name: null, phoneNumber: 'phoneNumber'),
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
          const ProfileLoaded(name: 'name', phoneNumber: 'phoneNumber'),
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
