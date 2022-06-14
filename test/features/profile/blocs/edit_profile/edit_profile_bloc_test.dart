import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/errors/failure.dart';
import 'package:storefront_app/features/auth/domain/domain.dart';
import 'package:storefront_app/features/profile/index.dart';

import '../../../../src/mock_customer_service_client.dart';

void main() {
  late ICustomerRepository customerRepository;
  late EditProfileBloc editProfileBloc;

  const String fullName = 'dummyName';

  setUp(() {
    customerRepository = MockCustomerRepository();
    editProfileBloc = EditProfileBloc(customerRepository);
  });

  tearDown(() {
    verifyNoMoreInteractions(customerRepository);
  });

  group('EditProfileBloc', () {
    blocTest<EditProfileBloc, EditProfileState>(
      'should emit profile name '
      'when FullNameChanged is added',
      build: () => editProfileBloc,
      act: (bloc) => bloc.add(const FullNameChanged(fullName)),
      expect: () => [const EditProfileState(fullName: fullName)],
    );

    blocTest<EditProfileBloc, EditProfileState>(
      'should emit error message '
      'when FormSubmitted event is added '
      'and repository returns failure',
      setUp: () {
        when(
          () =>
              customerRepository.updateFullName(editProfileBloc.state.fullName),
        ).thenAnswer((_) async => left(Failure('Error!')));
      },
      build: () => editProfileBloc,
      act: (bloc) => bloc.add(const FormSubmitted()),
      expect: () => [
        const EditProfileState(loading: true),
        const EditProfileState(errorMessage: 'Error!'),
      ],
      verify: (_) {
        verify(
          () =>
              customerRepository.updateFullName(editProfileBloc.state.fullName),
        ).called(1);
      },
    );

    blocTest<EditProfileBloc, EditProfileState>(
      'should emit valid state '
      'when FormSubmitted event is added '
      'and repository returns right',
      setUp: () {
        when(
          () =>
              customerRepository.updateFullName(editProfileBloc.state.fullName),
        ).thenAnswer((_) async => right(unit));
      },
      build: () => editProfileBloc,
      act: (bloc) => bloc.add(const FormSubmitted()),
      expect: () => [
        const EditProfileState(loading: true),
        const EditProfileState(profileUpdated: true),
      ],
      verify: (_) {
        verify(
          () =>
              customerRepository.updateFullName(editProfileBloc.state.fullName),
        ).called(1);
      },
    );
  });
}
