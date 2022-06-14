import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../auth/index.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

@injectable
class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final ICustomerRepository _repository;

  EditProfileBloc(this._repository) : super(const EditProfileState()) {
    on<FullNameChanged>(_onNameChanged);
    on<FormSubmitted>(_onFormSubmitted);
  }

  void _onNameChanged(FullNameChanged event, Emitter<EditProfileState> emit) {
    emit(state.copyWith(fullName: event.fullName));
  }

  Future<void> _onFormSubmitted(
    FormSubmitted event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    final result = await _repository.updateFullName(state.fullName);

    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: failure.message,
          loading: false,
        ),
      ),
      (success) => emit(
        state.copyWith(
          loading: false,
          profileUpdated: true,
        ),
      ),
    );
  }
}
