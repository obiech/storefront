part of 'language_selection_cubit.dart';

class LanguageSelectionState extends Equatable {
  final Locale locale;
  final bool localeUpdated;

  const LanguageSelectionState({
    required this.locale,
    this.localeUpdated = false,
  });

  LanguageSelectionState copyWith({
    Locale? locale,
    bool? localeUpdated,
  }) {
    return LanguageSelectionState(
      locale: locale ?? this.locale,
      localeUpdated: localeUpdated ?? this.localeUpdated,
    );
  }

  @override
  List<Object> get props => [locale, localeUpdated];
}
