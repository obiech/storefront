part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state of cubit.
class ProfileInitial extends ProfileState {}

/// When [ProfileCubit] loading user profile
/// from backend.
class ProfileLoading extends ProfileState {}

/// When [ProfileCubit] successfully retrieve
/// user profile from backend.
class ProfileLoaded extends ProfileState {
  final ProfileModel profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// When [ProfileCubit] failed to retrieve
/// user profile from backend.
class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
