class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}

class FetchDataException extends AppException {
  FetchDataException(String message) : super(message);
}

class BadRequestException extends AppException {
  BadRequestException(String message) : super(message);
}

class UnauthorizedException extends AppException {
  UnauthorizedException(String message) : super(message);
}

class NotFoundException extends AppException {
  NotFoundException(String message) : super(message);
}

class ServerException extends AppException {
  ServerException(String message) : super(message);
}
