import 'package:dartz/dartz.dart';
import 'package:must_invest_service_man/core/errors/app_error.dart';
import 'package:must_invest_service_man/core/preferences/shared_pref.dart';
import 'package:must_invest_service_man/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:must_invest_service_man/features/auth/data/models/auth_model.dart';
import 'package:must_invest_service_man/features/auth/data/models/city.dart';
import 'package:must_invest_service_man/features/auth/data/models/country.dart';
import 'package:must_invest_service_man/features/auth/data/models/governorate.dart';
import 'package:must_invest_service_man/features/auth/data/models/login_params.dart';
import 'package:must_invest_service_man/features/auth/data/models/register_params.dart';
import 'package:must_invest_service_man/features/auth/data/models/reset_password_params.dart';
import 'package:must_invest_service_man/features/auth/data/models/user.dart';
import 'package:must_invest_service_man/features/auth/data/models/verify_params.dart';

abstract class AuthRepo {
  Future<Either<ParkingMan, AppError>> autoLogin();
  Future<Either<AuthModel, AppError>> login(LoginParams params);
  Future<Either<AuthModel, AppError>> loginWithGoogle();
  Future<Either<AuthModel, AppError>> loginWithApple();
  Future<Either<void, AppError>> register(RegisterParams params);
  Future<Either<AuthModel, AppError>> verifyRegistration(VerifyParams params);
  Future<Either<void, AppError>> verifyPasswordReset(VerifyParams params);
  Future<Either<void, AppError>> resendOTP(String phone);
  Future<Either<void, AppError>> forgetPassword(String email);
  Future<Either<void, AppError>> resetPassword(ResetPasswordParams params);
  Future<Either<List<Country>, AppError>> getCountries(); // List<Country>
  Future<Either<List<Governorate>, AppError>> getGovernorates(int countryId); // List<Governorate>
  Future<Either<List<City>, AppError>> getCities(int governorateId); // List<City>
}

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _remoteDataSource;
  final MustInvestServiceManPreferences _localDataSource;

  AuthRepoImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<ParkingMan, AppError>> autoLogin() async {
    try {
      final token = _localDataSource.getToken();
      final response = await _remoteDataSource.autoLogin(token ?? '');

      if (response.isSuccess) {
        return Left(response.data!);
      } else {
        return Right(AppError(message: response.errorMessage, apiResponse: response, type: ErrorType.api));
      }
    } catch (e) {
      return Right(AppError(message: e.toString(), type: ErrorType.unknown));
    }
  }

  @override
  Future<Either<AuthModel, AppError>> login(LoginParams params) async {
    try {
      final response = await _remoteDataSource.login(params);

      if (response.isSuccess) {
        if (params.isRemembered) {
          _localDataSource.saveToken(response.data?.token ?? '');
        }
        return Left(response.data!);
      } else {
        return Right(AppError(message: response.errorMessage, apiResponse: response, type: ErrorType.api));
      }
    } catch (e) {
      return Right(AppError(message: e.toString(), type: ErrorType.unknown));
    }
  }

  @override
  Future<Either<AuthModel, AppError>> loginWithGoogle() async {
    throw UnimplementedError();
    // try {
    //   final response = await _remoteDataSource.loginWithGoogle();

    //   if (response.isSuccess) {
    //     _localDataSource.saveToken(response.accessToken ?? '');
    //     return Left(response.data!);
    //   } else {
    //     return Right(
    //       AppError(
    //         message: response.errorMessage,
    //         apiResponse: response,
    //         type: ErrorType.api,
    //       ),
    //     );
    //   }
    // } catch (e) {
    //   return Right(AppError(message: e.toString(), type: ErrorType.unknown));
    // }
  }

  @override
  Future<Either<AuthModel, AppError>> loginWithApple() async {
    throw UnimplementedError();
    // try {
    //   final response = await _remoteDataSource.loginWithApple(

    //   );

    //   if (response.isSuccess) {
    //     _localDataSource.saveToken(response.accessToken?? '');
    //     return Left(response.data!);
    //   } else {
    //     return Right(AppError(
    //       message: response.errorMessage,
    //       apiResponse: response,
    //       type: ErrorType.api,
    //     ));
    //   }
    // } catch (e) {
    //   return Right(AppError(
    //     message: e.toString(),
    //     type: ErrorType.unknown,
    //   ));
    // }
  }

  @override
  Future<Either<void, AppError>> register(RegisterParams params) async {
    try {
      final response = await _remoteDataSource.register(params);

      if (response.isSuccess) {
        _localDataSource.saveToken(response.accessToken ?? '');
        return Left(null);
      } else {
        return Right(AppError(message: response.errorMessage, apiResponse: response, type: ErrorType.api));
      }
    } catch (e) {
      return Right(AppError(message: e.toString(), type: ErrorType.unknown));
    }
  }

  @override
  Future<Either<void, AppError>> forgetPassword(String email) async {
    try {
      final response = await _remoteDataSource.forgetPassword(email);

      if (response.isSuccess) {
        return const Left(null);
      } else {
        return Right(AppError(message: response.errorMessage, apiResponse: response, type: ErrorType.api));
      }
    } catch (e) {
      return Right(AppError(message: e.toString(), type: ErrorType.unknown));
    }
  }

  @override
  Future<Either<void, AppError>> resetPassword(ResetPasswordParams params) async {
    try {
      final response = await _remoteDataSource.resetPassword(params);

      if (response.isSuccess) {
        return const Left(null);
      } else {
        return Right(AppError(message: response.errorMessage, apiResponse: response, type: ErrorType.api));
      }
    } catch (e) {
      return Right(AppError(message: e.toString(), type: ErrorType.unknown));
    }
  }

  @override
  Future<Either<List<City>, AppError>> getCities(int governorateId) async {
    try {
      final response = await _remoteDataSource.getCities(governorateId);

      if (response.isSuccess) {
        return Left(response.data!);
      } else {
        return Right(AppError(message: response.errorMessage, apiResponse: response, type: ErrorType.api));
      }
    } catch (e) {
      return Right(AppError(message: e.toString(), type: ErrorType.unknown));
    }
  }

  @override
  Future<Either<List<Country>, AppError>> getCountries() async {
    try {
      final response = await _remoteDataSource.getCountries();

      if (response.isSuccess) {
        return Left(response.data!);
      } else {
        return Right(AppError(message: response.errorMessage, apiResponse: response, type: ErrorType.api));
      }
    } catch (e) {
      return Right(AppError(message: e.toString(), type: ErrorType.unknown));
    }
  }

  @override
  Future<Either<List<Governorate>, AppError>> getGovernorates(int countryId) async {
    try {
      final response = await _remoteDataSource.getGovernorates(countryId);

      if (response.isSuccess) {
        return Left(response.data!);
      } else {
        return Right(AppError(message: response.errorMessage, apiResponse: response, type: ErrorType.api));
      }
    } catch (e) {
      return Right(AppError(message: e.toString(), type: ErrorType.unknown));
    }
  }

  @override
  Future<Either<AuthModel, AppError>> verifyRegistration(VerifyParams params) async {
    try {
      final response = await _remoteDataSource.verifyRegistration(params);

      if (response.isSuccess) {
        _localDataSource.saveToken(response.data?.token ?? '');
        return Left(response.data!);
      } else {
        return Right(AppError(message: response.errorMessage, apiResponse: response, type: ErrorType.api));
      }
    } catch (e) {
      return Right(AppError(message: e.toString(), type: ErrorType.unknown));
    }
  }

  @override
  Future<Either<void, AppError>> resendOTP(String phone) async {
    try {
      final response = await _remoteDataSource.resendOtp(phone);

      if (response.isSuccess) {
        return const Left(null);
      } else {
        return Right(AppError(message: response.errorMessage, apiResponse: response, type: ErrorType.api));
      }
    } catch (e) {
      return Right(AppError(message: e.toString(), type: ErrorType.unknown));
    }
  }

  @override
  Future<Either<void, AppError>> verifyPasswordReset(VerifyParams params) async {
    try {
      final response = await _remoteDataSource.verifyPasswordReset(params);

      if (response.isSuccess) {
        return const Left(null);
      } else {
        return Right(AppError(message: response.errorMessage, apiResponse: response, type: ErrorType.api));
      }
    } catch (e) {
      return Right(AppError(message: e.toString(), type: ErrorType.unknown));
    }
  }
}
