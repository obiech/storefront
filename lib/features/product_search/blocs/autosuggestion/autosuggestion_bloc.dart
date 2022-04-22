import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';

import '../../index.dart';

part 'autosuggestion_event.dart';
part 'autosuggestion_state.dart';

/// The product inventory search page should provide
/// search suggestions to a user
@injectable
class AutosuggestionBloc
    extends Bloc<AutosuggestionEvent, AutosuggestionState> {
  final IProductSearchRepository repository;

  AutosuggestionBloc(this.repository) : super(AutoSuggestionInitial()) {
    on<GetSuggestions>(
      _getAutosuggestions,
      transformer: debounce(const Duration(milliseconds: 300)),
    );

    on<ResetSuggestions>(
      (event, emit) => emit(AutoSuggestionInitial()),
    );
  }

  FutureOr<void> _getAutosuggestions(
    GetSuggestions event,
    Emitter<AutosuggestionState> emit,
  ) async {
    emit(GettingAutosuggestions());

    try {
      final suggestions = await repository.getSearchSuggestions(event.query);
      if (kDebugMode) {
        print(suggestions);
      }
      emit(LoadedAutosuggestions(suggestions));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(const ErrorGettingAutosuggestions('Failed to load autosuggestions'));
    }
  }
}