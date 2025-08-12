import 'package:must_invest_service_man/core/api/dio_client.dart';
import 'package:must_invest_service_man/core/api/end_points.dart';
import 'package:must_invest_service_man/core/api/response/response.dart';
import 'package:must_invest_service_man/core/extensions/token_to_authorization_options.dart';
import 'package:must_invest_service_man/features/home/data/models/user_model.dart';

abstract class HomeRemoteDataSource {
  Future<ApiResponse<UserListResponse>> getCurrentUsersInParking(String token);
  Future<ApiResponse<UserModel>> getUserDetails(String token, int userId);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient dioClient;

  HomeRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ApiResponse<UserListResponse>> getCurrentUsersInParking(String token) {
    return dioClient.request<UserListResponse>(
      method: RequestMethod.get,
      EndPoints.currentUsersInParking,
      options: token.toAuthorizationOptions(),
      fromJson: (json) => UserListResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<UserModel>> getUserDetails(String token, int userId) async {
    return dioClient.request<UserModel>(
      method: RequestMethod.get,
      EndPoints.userDetails(userId),
      options: token.toAuthorizationOptions(),
      fromJson: (json) => UserModel.fromJson((json as Map<String, dynamic>)),
    );
  }
}
