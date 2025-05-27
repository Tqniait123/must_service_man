import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:must_invest_service_man/core/api/response/response.dart';
import 'package:must_invest_service_man/core/connection/network_info.dart';
import 'package:must_invest_service_man/core/errors/app_exception.dart';
import 'package:must_invest_service_man/core/errors/exceptions.dart';
import 'package:must_invest_service_man/core/services/di.dart';

mixin SendTokenRequestMixin {
  Future<(T, String)> sendTokenRequest<T>(
    Future<ApiResponse<T>> Function() request,
  ) async {
    final networkInfo = sl<NetworkInfo>();
    if (await networkInfo.isConnected == ConnectivityResult.none) {
      throw NoInternetException();
    }

    var response = await request();

    if (response is BadInputResponse<T>) {
      throw BadInputException(response.errors);
    }

    if (response is ErrorResponse<T>) {
      throw AppException(response.message);
    }

    if (response is! TokenResponse<T>) {
      throw NoTokenException();
    }

    return (response.data, response.token);
  }
}
