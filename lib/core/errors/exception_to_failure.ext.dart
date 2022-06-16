part of 'failure.dart';

extension ExceptionToFailureX on Exception {
  /// Transforms different types of [Exception]s into
  /// corresponding [Failure]s
  Failure get toFailure {
    if (this is GrpcError) {
      return NetworkFailure.fromGrpcError(this as GrpcError);
    } else if (this is SocketException) {
      return NoInternetFailure();
    } else if (this is TimeoutException) {
      debugPrint('Encountered ${(this as TimeoutException).duration}');
      return TimeoutFailure();
    } else if (this is FormatException) {
      final errMsg = (this as FormatException).toString();
      debugPrint('Encountered a FormatException: $errMsg');

      return Failure('Failed to format incoming data.');
    } else if (this is PlacesApiException) {
      final errorMessage = (this as PlacesApiException).message;

      return Failure(errorMessage);
    } else {
      debugPrint('Encountered unhandled Exceptions: ${toString()}');
      return Failure('An unknown error has occured');
    }
  }
}
