part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileLoaded extends ProfileState {
  final String? name;
  final String phoneNumber;

  const ProfileLoaded({
    required this.name,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [name, phoneNumber];
}
