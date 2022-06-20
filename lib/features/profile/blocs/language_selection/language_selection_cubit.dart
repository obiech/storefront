import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'language_selection_state.dart';

@injectable
class LanguageSelectionCubit extends Cubit<LanguageSelectionState> {
  //TODO:(jeco) Get locale from prefs repository
  LanguageSelectionCubit()
      : super(const LanguageSelectionState(locale: Locale('id', 'ID')));

  void onLocaleChanged(Locale locale) {
    emit(state.copyWith(locale: locale));
  }

  void submitLocale() {
    //TODO: Set device locale
    emit(state.copyWith(localeUpdated: true));
  }
}
