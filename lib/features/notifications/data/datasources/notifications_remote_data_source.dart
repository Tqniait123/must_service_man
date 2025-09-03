import 'package:must_invest_service_man/core/api/dio_client.dart';
import 'package:must_invest_service_man/core/api/end_points.dart';
import 'package:must_invest_service_man/core/api/response/response.dart';
import 'package:must_invest_service_man/core/extensions/token_to_authorization_options.dart';
import 'package:must_invest_service_man/features/notifications/data/models/notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<ApiResponse<List<NotificationModel>>> getNotifications(String token);
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final DioClient dioClient;

  NotificationsRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ApiResponse<List<NotificationModel>>> getNotifications(String token) async {
    return dioClient.request<List<NotificationModel>>(
      method: RequestMethod.get,
      EndPoints.notifications,
      options: token.toAuthorizationOptions(),
      fromJson: (json) {
        final notificationsData = (json as Map<String, dynamic>)['notifications'] as List;
        return notificationsData
            .map((notification) => NotificationModel.fromJson(notification as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
