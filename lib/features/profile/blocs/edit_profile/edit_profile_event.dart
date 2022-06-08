part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();
}

/// Event to change [fullName] and save it to state
class FullNameChanged extends EditProfileEvent {
  final String fullName;

  const FullNameChanged(this.fullName);

  @override
  List<Object?> get props => [fullName];
}

/// Event when Address detail form is submitted
class FormSubmitted extends EditProfileEvent {
  const FormSubmitted();

  @override
  List<Object?> get props => [];
}
