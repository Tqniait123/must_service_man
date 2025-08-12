import 'package:dartz/dartz.dart';
import 'package:must_invest_service_man/core/errors/app_error.dart';
import 'package:must_invest_service_man/core/preferences/shared_pref.dart';
import 'package:must_invest_service_man/features/home/data/models/user_model.dart';

import '../datasources/home_remote_data_source.dart';

abstract class HomeRepo {
  Future<Either<UserListResponse, AppError>> getCurrentUsersInParking();
  Future<Either<UserModel, AppError>> getUserDetails(int userId);
}

class HomeRepoImpl implements HomeRepo {
  final HomeRemoteDataSource _remoteDataSource;
  final MustInvestServiceManPreferences _localDataSource;

  HomeRepoImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<UserListResponse, AppError>> getCurrentUsersInParking() async {
    try {
      final token = _localDataSource.getToken();
      final response = await _remoteDataSource.getCurrentUsersInParking(token ?? '');

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
  Future<Either<UserModel, AppError>> getUserDetails(int userId) async {
    try {
      final token = _localDataSource.getToken();
      final response = await _remoteDataSource.getUserDetails(token ?? '', userId);

      if (response.isSuccess) {
        return Left(response.data!);
      } else {
        return Right(AppError(message: response.errorMessage, apiResponse: response, type: ErrorType.api));
      }
    } catch (e) {
      return Right(AppError(message: e.toString(), type: ErrorType.unknown));
    }
  }
}
