part of 'autosuggestion_bloc.dart';

abstract class AutosuggestionState extends Equatable {
  const AutosuggestionState();

  @override
  List<Object> get props => [];
}

class AutoSuggestionInitial extends AutosuggestionState {}

/// Loading Auto Suggestions
class GettingAutosuggestions extends AutosuggestionState {}

/// When an error occurs while loading Auto Suggestions
class ErrorGettingAutosuggestions extends AutosuggestionState {
  /// The error message
  final String message;

  const ErrorGettingAutosuggestions(this.message);

  @override
  List<Object> get props => [message];
}

/// When Auto Suggestions have been successfully returned
class LoadedAutosuggestions extends AutosuggestionState {
  /// The suggestion strings
  final List<String> suggestions;

  const LoadedAutosuggestions(this.suggestions);

  @override
  List<Object> get props => [suggestions];
}
