import 'package:must_invest_service_man/features/auth/data/models/user.dart';

class AuthModel {
  final ParkingMan user;
  final String? token;

  AuthModel({required this.user, this.token});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      user: ParkingMan.fromJson(json['employer']),
      token: json['access_token'],
      // hasSubscription: json['has_subscription'],
    );
  }
}
