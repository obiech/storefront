import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/errors/failure.dart';
import 'package:storefront_app/features/profile/index.dart';

import '../../mocks.dart';

void main() {
  late IProfileRepository profileRepository;
  late EditProfileBloc editProfileBloc;

  const String fullName = 'dummyName';

  setUp(() {
    profileRepository = MockProfileRepository();
    editProfileBloc = EditProfileBloc(profileRepository);
  });

  tearDown(() {
    verifyNoMoreInteractions(profileRepository);
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
          () => profileRepository.saveFullName(editProfileBloc.state.fullName),
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
          () => profileRepository.saveFullName(editProfileBloc.state.fullName),
        ).called(1);
      },
    );

    blocTest<EditProfileBloc, EditProfileState>(
      'should emit valid state '
      'when FormSubmitted event is added '
      'and repository returns right',
      setUp: () {
        when(
          () => profileRepository.saveFullName(editProfileBloc.state.fullName),
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
          () => profileRepository.saveFullName(editProfileBloc.state.fullName),
        ).called(1);
      },
    );
  });
}
