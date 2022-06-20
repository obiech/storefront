import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';

part 'language_selection_state.dart';

@injectable
class LanguageSelectionCubit extends Cubit<LanguageSelectionState> {
  final IPrefsRepository prefsRepository;

  LanguageSelectionCubit(this.prefsRepository)
      : super(
          LanguageSelectionState(
            locale: prefsRepository.getDeviceLocale(),
          ),
        );

  void onLocaleChanged(Locale locale) {
    emit(state.copyWith(locale: locale));
  }

  void submitLocale() {
    prefsRepository.setDeviceLocale(state.locale);
    emit(state.copyWith(localeUpdated: true));
  }
}
