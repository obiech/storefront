import 'package:flutter/material.dart';
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

/// a [BlocListener] that will accepts only a single State
class SingleStateListener<T extends S, B extends StateStreamable<S>, S>
    extends BlocListener<B, S> {
  SingleStateListener({
    Key? key,
    required this.callback,
    Widget? child,
  }) : super(
          key: key,
          listenWhen: (_, curr) => curr is T,
          listener: (context, state) {
            if (state is T) {
              callback.call(context, state);
            }
          },
          child: child,
        );

  final Function(BuildContext, T) callback;
}
