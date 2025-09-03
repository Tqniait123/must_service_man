import 'package:must_invest_service_man/core/api/dio_client.dart';
import 'package:must_invest_service_man/core/api/end_points.dart';
import 'package:must_invest_service_man/core/api/response/response.dart';
import 'package:must_invest_service_man/core/extensions/token_to_authorization_options.dart';
import 'package:must_invest_service_man/features/home/data/models/daily_point_model.dart';
import 'package:must_invest_service_man/features/home/data/models/user_model.dart';
import 'package:must_invest_service_man/features/home/data/models/withdraw_params.dart';

abstract class HomeRemoteDataSource {
  Future<ApiResponse<UserListResponse>> getCurrentUsersInParking(String token);
  Future<ApiResponse<UserModel>> getUserDetails(String token, int userId);
  Future<ApiResponse<void>> walletWithdraw(String token, WithdrawParams params);
  Future<ApiResponse<List<DailyPointModel>>> getDailyPoints(String token);
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

  @override
  Future<ApiResponse<void>> walletWithdraw(String token, WithdrawParams params) async {
    return dioClient.request<void>(
      method: RequestMethod.post,
      EndPoints.walletWithdraw,
      data: params.toJson(),
      options: token.toAuthorizationOptions(),
      fromJson: (json) {}, // We don't need to parse data, just return null
    );
  }

  @override
  Future<ApiResponse<List<DailyPointModel>>> getDailyPoints(String token) async {
    // return dioClient.request<List<DailyPointModel>>(
    //   method: RequestMethod.get,
    //   EndPoints.dailyPoints,
    //   options: token.toAuthorizationOptions(),
    //   fromJson: (json) {
    //     final data = json as Map<String, dynamic>;
    //     final pointsList = data['data'] as List<dynamic>? ?? [];
    //     return pointsList
    //         .map((point) => DailyPointModel.fromJson(point as Map<String, dynamic>))
    //         .toList();
    //   },
    // );

    await Future.delayed(const Duration(seconds: 2));
    final fakeResponse = DailyPointsResponse.fake();
    return ApiResponse(data: fakeResponse.data, message: fakeResponse.message, statusCode: ApiStatusCode.ok);
  }
}
