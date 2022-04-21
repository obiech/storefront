part of 'autosuggestion_bloc.dart';

abstract class AutosuggestionEvent extends Equatable {}

/// Get product suggestions from inventory
class GetSuggestions extends AutosuggestionEvent {
  final String query;

  GetSuggestions(this.query);

  @override
  List<Object?> get props => [query];
}

/// Reset product suggestions to empty
class ResetSuggestions extends AutosuggestionEvent {
  @override
  List<Object?> get props => [];
}
