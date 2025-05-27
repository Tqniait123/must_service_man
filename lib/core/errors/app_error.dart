import 'package:must_invest_service_man/core/api/response/response.dart';

class AppError {
  final String message;
  final ApiResponse? apiResponse;
  final ErrorType type;

  AppError({required this.message, this.apiResponse, required this.type});
}

enum ErrorType { network, api, parsing, unknown }
