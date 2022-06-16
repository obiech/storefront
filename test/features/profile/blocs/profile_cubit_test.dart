import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/errors/failure.dart';
import 'package:storefront_app/features/auth/index.dart';
import 'package:storefront_app/features/profile/blocs/blocs.dart';

import '../../../../test_commons/fixtures/profile/profile_model.dart';
import '../../../src/mock_customer_service_client.dart';

void main() {
  late ICustomerRepository customerRepository;
  late ProfileCubit profileCubit;

  const fullName = 'dummyName';

  setUp(() {
    customerRepository = MockCustomerRepository();
    profileCubit = ProfileCubit(customerRepository: customerRepository);
  });

  group(
    '[ProfileCubit]',
    () {
      test(
        'should start with Initial state',
        () {
          expect(profileCubit.state, isA<ProfileInitial>());
        },
      );

      group(
        '[fetchProfile()]',
        () {
          blocTest<ProfileCubit, ProfileState>(
            'should emit Loading state followed by Loaded state if '
            'Profile is returned',
            setUp: () {
              when(
                () => customerRepository.getProfile(),
              ).thenAnswer(
                (_) async => right(mockProfile),
              );
            },
            build: () => profileCubit,
            act: (cubit) async => cubit.fetchProfile(),
            expect: () => [
              ProfileLoading(),
              const ProfileLoaded(mockProfile),
            ],
            verify: (cubit) {
              verify(() => customerRepository.getProfile()).called(1);
            },
          );

          blocTest<ProfileCubit, ProfileState>(
            'should emit Loading state followed by Error state if '
            'a Failure is returned',
            setUp: () {
              when(
                () => customerRepository.getProfile(),
              ).thenAnswer(
                (_) async => left(Failure('An unexpected error occured.')),
              );
            },
            build: () => profileCubit,
            act: (cubit) async => cubit.fetchProfile(),
            expect: () {
              return [
                ProfileLoading(),
                const ProfileError('An unexpected error occured.'),
              ];
            },
            verify: (cubit) {
              verify(() => customerRepository.getProfile()).called(1);
            },
          );
        },
      );

      group('[refreshUpdatedName()]', () {
        blocTest<ProfileCubit, ProfileState>(
          'should emit Loaded state with '
          'new full name',
          setUp: () async {
            when(
              () => customerRepository.getProfile(),
            ).thenAnswer(
              (_) async => right(mockProfile),
            );
            await profileCubit.fetchProfile();
          },
          build: () => profileCubit,
          act: (cubit) => cubit.refreshUpdatedName(fullName),
          expect: () => [
            ProfileLoaded(mockProfile.copyWith(fullName: fullName)),
          ],
        );
      });
    },
  );
}
