part of 'edit_profile_bloc.dart';

class EditProfileState extends Equatable {
  /// [fullName] will change when fullname field value change
  final String fullName;

  /// [loading] will be true when loading data from remote
  final bool loading;

  /// [errorMessage] will be non-null when form submission failed
  final String? errorMessage;

  /// [profileUpdated] will be true when form submission is successful
  final bool profileUpdated;

  const EditProfileState({
    this.fullName = '',
    this.loading = false,
    this.errorMessage,
    this.profileUpdated = false,
  });

  EditProfileState copyWith({
    String? fullName,
    bool? loading,
    String? errorMessage,
    bool? profileUpdated,
  }) {
    return EditProfileState(
      fullName: fullName ?? this.fullName,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
      profileUpdated: profileUpdated ?? this.profileUpdated,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        loading,
        errorMessage,
        profileUpdated,
      ];
}
