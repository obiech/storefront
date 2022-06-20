/// Thrown when required device service is disabled
/// i.e. location service
class ServiceException implements Exception {
  final String message;
  final Object? exception;

  ServiceException({
    this.exception,
    required this.message,
  });

  @override
  String toString() => message;
}
