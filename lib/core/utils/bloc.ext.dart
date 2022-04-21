import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

/// For actions search as search that could overwhelm
/// the backend with requests, we can use the debounce
/// transformer to buffer the requests within a certain
/// [duration]. This way every request within the Bloc
/// will happen in buffered intervals.
///
/// Usage
/// ```
/// SomeBloc() : super(SomeInitial()) {
///     on<SomeEvent>(
///       (event, emit) {
///         // Implement event handler
///       },
///       transformer: debounce(const Duration(milliseconds: 300)),
///     );
///   }
///   ```
EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}
