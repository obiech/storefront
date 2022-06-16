import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../auth/index.dart';
import '../index.dart';

part 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required this.customerRepository,
  }) : super(ProfileInitial());

  final ICustomerRepository customerRepository;

  /// Fetch profile from backend.
  Future<void> fetchProfile() async {
    emit(ProfileLoading());

    final result = await customerRepository.getProfile();

    final newState = result.fold(
      (failure) => ProfileError(failure.message),
      (profile) => ProfileLoaded(profile),
    );

    emit(newState);
  }

  /// Refresh profile with updated full name.
  ///
  /// Do nothing if profile not loaded.
  void refreshUpdatedName(String fullName) {
    if (state is! ProfileLoaded) return;
    emit(
      ProfileLoaded(
        (state as ProfileLoaded).profile.copyWith(fullName: fullName),
      ),
    );
  }
}
