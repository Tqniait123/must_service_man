import 'package:dartz/dartz.dart';
import 'package:must_invest_service_man/config/app_settings/data/datasources/settings_remote_data_source.dart';
import 'package:must_invest_service_man/config/app_settings/data/models/app_settings_model.dart';
import 'package:must_invest_service_man/core/api/dio_client.dart';
import 'package:must_invest_service_man/core/api/end_points.dart';
import 'package:must_invest_service_man/core/errors/app_error.dart';

class AppSettingsRemoteDataSourceImpl implements AppSettingsRemoteDataSource {
  final DioClient _dio;

  AppSettingsRemoteDataSourceImpl(this._dio);

  @override
  Future<Either<AppSettings, String>> getAppSettings() async {
    try {
      final response = await _dio.request<AppSettings>(
        EndPoints.appSettings,
        method: RequestMethod.get,
        fromJson: (json) => AppSettings.fromJson(json as Map<String, dynamic>),
      );

      return Left(response.data!);
    } on AppError catch (e) {
      return Right(e.message);
    } catch (e) {
      return Right(e.toString());
    }
  }
}
