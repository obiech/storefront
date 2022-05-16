import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  // TODO: Update with proper logic
  void loadProfile() {
    emit(
      const ProfileLoaded(
        name: null,
        phoneNumber: '0812123400',
      ),
    );
  }
}
