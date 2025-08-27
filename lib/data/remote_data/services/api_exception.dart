class AppException implements Exception {
  final String? _prefix;
  final String? _message;

  AppException([this._prefix, this._message]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException({required String errorMsg})
      : super("Error During Communication: ", errorMsg);
}

class BadRequestException extends AppException {
  BadRequestException({required String errorMsg})
      : super("Invalid Request: ", errorMsg);
}

class UnauthorisedException extends AppException {
  UnauthorisedException({required String errorMsg})
      : super("Unauthorised: ", errorMsg);
}