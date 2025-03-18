class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status code: $statusCode)';
}

class TokenExpiredException extends ApiException {
  TokenExpiredException() : super('Token has expired', statusCode: 401);
}

class NetworkException extends ApiException {
  NetworkException() : super('No internet connection');
}

class ServerException extends ApiException {
  ServerException(super.message, {super.statusCode});
}
