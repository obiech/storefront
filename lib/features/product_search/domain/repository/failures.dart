import 'package:storefront_app/core/core.dart';

/// Base for search errors
class SearchFailure extends Failure {
  SearchFailure(String message) : super(message);
}

// When inventory search response is empty
class NoInventoryResults extends SearchFailure {
  NoInventoryResults() : super('No such item in inventory');
}

// When suggestions response is empty
class NoSuggestionResults extends SearchFailure {
  NoSuggestionResults() : super('No suggestions');
}

// When network error occurs
class NetworkError extends SearchFailure {
  final Failure failure;

  NetworkError(this.failure) : super(failure.message);
}
