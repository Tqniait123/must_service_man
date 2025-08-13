import 'package:dartz/dartz.dart';
import 'package:must_invest_service_man/core/errors/app_error.dart';
import 'package:must_invest_service_man/core/preferences/shared_pref.dart';
import 'package:must_invest_service_man/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:must_invest_service_man/features/notifications/data/models/notification_model.dart';

abstract class NotificationsRepo {
  Future<Either<List<NotificationModel>, AppError>> getNotifications();
}

class NotificationsRepoImpl implements NotificationsRepo {
  final NotificationsRemoteDataSource _remoteDataSource;
  final MustInvestServiceManPreferences _localDataSource;

  NotificationsRepoImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<List<NotificationModel>, AppError>> getNotifications() async {
    try {
      final token = _localDataSource.getToken();
      final response = await _remoteDataSource.getNotifications(token ?? '');

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
