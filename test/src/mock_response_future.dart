import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';

/// Used for mocking [ResponseFuture] from gRPC method calls
///
/// To return a successful response, use [MockResponseFuture.value]
///
/// To return a failed response, use [MockResponseFuture.error]
class MockResponseFuture<T> extends Mock implements ResponseFuture<T> {
  final Future<T> future;

  MockResponseFuture.value(T value) : future = Future.value(value);

  MockResponseFuture.error(Object error) : future = Future.error(error);

  MockResponseFuture.future(this.future);

  @override
  Future<S> then<S>(FutureOr<S> Function(T value) onValue,
          {Function? onError}) =>
      future.then(onValue, onError: onError);
}
