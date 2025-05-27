import 'package:easy_localization/easy_localization.dart';
import 'package:must_invest_service_man/core/api/response/response.dart';
import 'package:must_invest_service_man/core/errors/app_exception.dart';

class NoInternetException extends AppException {
  NoInternetException() : super('no internet connection');
}

class NoTokenException extends AppException {
  NoTokenException() : super("Auth token expected, none recieved.");
}

class AutoLoginException extends AppException {
  AutoLoginException() : super("No token is saved locally");
}

class LoginException extends AppException {
  final String code;

  LoginException(this.code) : super(code.tr());
}

class UnsupportedImageTypeException extends AppException {
  UnsupportedImageTypeException() : super("Unsupported Image Type.");
}

class UnauthenticatedException extends AppException {
  UnauthenticatedException() : super("User Unauthenticated");
}

class BadInputException extends AppException {
  final Map<String, ResponseCode> errors;
  BadInputException(this.errors) : super('bad input');
}

class ServerException extends AppException {
  ServerException() : super("Something went wrong");
}
