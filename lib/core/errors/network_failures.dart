part of 'failure.dart';

/// For other network errors that do not require
/// special error handling in the form of popups or pages
/// designed specifically for the error
///
/// e.g. unknown error message, internal server error
class NetworkFailure extends Failure {
  NetworkFailure([String? message])
      : super(
          message ?? 'Something went wrong. Please try again.',
        );

  factory NetworkFailure.fromGrpcError(GrpcError error) {
    switch (error.code) {
      case StatusCode.invalidArgument:
        return InvalidArgumentFailure(error.message);
      case StatusCode.unauthenticated:
        return UnauthenticatedFailure(error.message);
      case StatusCode.unavailable:
        return NoInternetFailure();
      case StatusCode.notFound:
        return ResourceNotFoundFailure(error.message);
      case StatusCode.permissionDenied:
        return ResourceForbiddenFailure(error.message);
      default:
        return NetworkFailure(error.message);
    }
  }
}

/// When a request timed out.
class TimeoutFailure extends NetworkFailure {
  TimeoutFailure([String? message])
      : super(
          message ?? 'Failed to connect to our servers. Please try again.',
        );
}

/// When device has no internet connection.
class NoInternetFailure extends NetworkFailure {
  NoInternetFailure([String? message])
      : super(
          message ?? 'Please check your internet connection and try again.',
        );
}

/// When request contains invalid arguments.
///
/// i.e. http 400 or gRPC Invalid Argument error
class InvalidArgumentFailure extends NetworkFailure {
  InvalidArgumentFailure([String? message])
      : super(
          message ?? 'Please check the fields',
        );
}

/// When backend returns unauthenticated.
///
/// i.e. http 401 or gRPC Unauthenticated error
class UnauthenticatedFailure extends NetworkFailure {
  UnauthenticatedFailure([String? message])
      : super(
          message ?? 'Your session has expired.',
        );
}

/// When user has no access to this resource.
///
/// e.g. http 403 or gRPC Permission Denied error
/// when accessing endpoints reserved for Dropezy internal use
class ResourceForbiddenFailure extends NetworkFailure {
  ResourceForbiddenFailure([String? message])
      : super(
          message ?? 'You do not have access to this resource.',
        );
}

/// When requested resource is not found.
///
/// e.g. failed to find an order with a particular ID
class ResourceNotFoundFailure extends NetworkFailure {
  ResourceNotFoundFailure([String? message])
      : super(
          message ?? 'We could not find the resource you are looking for.',
        );
}

/// When backend is unavailable.
///
/// e.g. down for maintenance, server is overloaded with requests
class ServerUnavailableFailure extends NetworkFailure {
  ServerUnavailableFailure([String? message])
      : super(
          message ??
              'Sorry, our servers are currently busy. Please try again later.',
        );
}
