import 'package:must_invest_service_man/core/api/dio_client.dart';
import 'package:must_invest_service_man/core/api/end_points.dart';
import 'package:must_invest_service_man/core/api/response/response.dart';
import 'package:must_invest_service_man/core/extensions/token_to_authorization_options.dart';
import 'package:must_invest_service_man/features/auth/data/models/auth_model.dart';
import 'package:must_invest_service_man/features/auth/data/models/city.dart';
import 'package:must_invest_service_man/features/auth/data/models/country.dart';
import 'package:must_invest_service_man/features/auth/data/models/governorate.dart';
import 'package:must_invest_service_man/features/auth/data/models/login_params.dart';
import 'package:must_invest_service_man/features/auth/data/models/login_with_apple.dart';
import 'package:must_invest_service_man/features/auth/data/models/login_with_google_params.dart';
import 'package:must_invest_service_man/features/auth/data/models/register_params.dart';
import 'package:must_invest_service_man/features/auth/data/models/reset_password_params.dart';
import 'package:must_invest_service_man/features/auth/data/models/user.dart';
import 'package:must_invest_service_man/features/auth/data/models/verify_params.dart';

abstract class AuthRemoteDataSource {
  // Future<ApiResponse> login();
  Future<ApiResponse<ParkingMan>> autoLogin(String token);
  Future<ApiResponse<AuthModel>> login(LoginParams params);
  Future<ApiResponse<AuthModel>> loginWithGoogle(LoginWithGoogleParams loginWithGoogleParams);
  Future<ApiResponse<AuthModel>> loginWithApple(LoginWithAppleParams loginWithAppleParams);
  Future<ApiResponse<void>> register(RegisterParams params);
  Future<ApiResponse<AuthModel>> verifyRegistration(VerifyParams params);
  Future<ApiResponse<void>> verifyPasswordReset(VerifyParams params);
  Future<ApiResponse<void>> resendOtp(String phone);
  Future<ApiResponse<void>> forgetPassword(String email);
  Future<ApiResponse<void>> resetPassword(ResetPasswordParams params);
  Future<ApiResponse<List<Country>>> getCountries();
  Future<ApiResponse<List<Governorate>>> getGovernorates(int countryId);
  Future<ApiResponse<List<City>>> getCities(int governorateId);
  Future<ApiResponse<void>> deleteAccount(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;
  // final FcmService fcmService;
  AuthRemoteDataSourceImpl(this.dioClient);

  /// The function `autoLogin` sends a POST request to the `autoLogin` endpoint with login parameters
  /// and returns an ApiResponse containing an AppUser object.
  ///
  /// Args:
  ///   params (LoginParams): The `autoLogin` method takes a `LoginParams` object as a parameter. This
  /// object likely contains the necessary information for the auto-login process, such as username and
  /// password. The `toJson()` method is likely used to convert the `LoginParams` object into a JSON
  /// format that can be sent
  ///
  /// Returns:
  ///   A `Future` of type `ApiResponse<AppUser>` is being returned.
  @override
  Future<ApiResponse<ParkingMan>> autoLogin(String token) async {
    return dioClient.request<ParkingMan>(
      method: RequestMethod.get,
      EndPoints.autoLogin,
      options: token.toAuthorizationOptions(),
      fromJson: (json) => ParkingMan.fromJson(json as Map<String, dynamic>),
    );
  }

  /// The function `login` sends a POST request to the login endpoint with the provided parameters and
  /// returns an ApiResponse containing an AuthModel.
  ///
  /// Args:
  ///   params (LoginParams): The `params` parameter is an instance of the `LoginParams` class, which
  /// contains the username and password of the user trying to log in.
  ///
  /// Returns:
  ///   The `login` method is returning a `Future` that resolves to an `ApiResponse` containing an
  /// `AuthModel` object.
  @override
  Future<ApiResponse<AuthModel>> login(LoginParams params) async {
    // final deviceToken = await fcmService.getDeviceToken();

    return dioClient.request<AuthModel>(
      method: RequestMethod.post,
      EndPoints.login,
      data: params.toJson(),
      fromJson: (json) => AuthModel.fromJson(json as Map<String, dynamic>),
      onSuccess: () {
        // fcmService.subscribeToTopic(Constants.allTopic);
      },
    );
  }

  /// The function `loginWithGoogle` sends a POST request to the login endpoint with Google authentication
  /// parameters and returns an ApiResponse containing an AuthModel.
  ///
  /// Args:
  ///   loginWithGoogleParams (LoginWithGoogleParams): Contains the Google authentication credentials
  /// and other required parameters for logging in with Google.
  ///
  /// Returns:
  ///   A Future that resolves to an ApiResponse containing an AuthModel object with the authenticated
  /// user's data and tokens.
  @override
  Future<ApiResponse<AuthModel>> loginWithGoogle(LoginWithGoogleParams loginWithGoogleParams) async {
    // final deviceToken = await fcmService.getDeviceToken();
    return dioClient.request<AuthModel>(
      method: RequestMethod.post,
      EndPoints.loginWithGoogle,
      // data: loginWithGoogleParams.toJson(deviceToken ?? ''),
      fromJson: (json) => AuthModel.fromJson(json as Map<String, dynamic>),
      onSuccess: () {
        // fcmService.subscribeToTopic(Constants.allTopic);
      },
    );
  }

  /// The function `loginWithApple` sends a POST request to the login endpoint with Apple authentication
  /// parameters and returns an ApiResponse containing an AuthModel.
  ///
  /// Args:
  ///   loginWithAppleParams (LoginWithAppleParams): Contains the Apple authentication credentials
  /// and other required parameters for logging in with Apple.
  ///
  /// Returns:
  ///   A Future that resolves to an ApiResponse containing an AuthModel object with the authenticated
  /// user's data and tokens.
  @override
  Future<ApiResponse<AuthModel>> loginWithApple(LoginWithAppleParams loginWithAppleParams) async {
    // final deviceToken = await fcmService.getDeviceToken();
    return dioClient.request<AuthModel>(
      method: RequestMethod.post,
      EndPoints.loginWithApple,
      // data: loginWithAppleParams.toJson(deviceToken ?? ''),
      fromJson: (json) => AuthModel.fromJson(json as Map<String, dynamic>),
      onSuccess: () {
        // fcmService.subscribeToTopic(Constants.allTopic);
      },
    );
  }

  /// The function `register` sends a POST request to the register endpoint with the provided parameters
  /// and returns an ApiResponse containing an AuthModel.
  ///
  /// Args:
  ///   params (RegisterParams): The `register` method you provided seems to be a part of a class that
  /// implements an interface or extends a base class with a method signature like
  /// `Future<ApiResponse<AuthModel>> register(RegisterParams params)`.
  ///
  /// Returns:
  ///   The `register` method is returning a `Future` that resolves to an `ApiResponse` containing an
  /// `AuthModel` object.
  @override
  Future<ApiResponse<void>> register(RegisterParams params) async {
    return dioClient.request<void>(
      method: RequestMethod.post,
      EndPoints.register,
      data: params.toJson(),
      fromJson: (json) => (),
      onSuccess: () {
        // fcmService.subscribeToTopic(Constants.allTopic);
      },
    );
  }

  /// The `forgetPassword` function sends a POST request to the `register` endpoint with the provided
  /// email for password reset.
  ///
  /// Args:
  ///   email (String): The `forgetPassword` method is used to send a request to the server to reset a
  /// user's password. The `email` parameter is the email address of the user for whom the password reset
  /// request is being made.
  ///
  /// Returns:
  ///   The `forgetPassword` method is returning a `Future` that resolves to an `ApiResponse<void>`.
  @override
  Future<ApiResponse<void>> forgetPassword(String phone) async {
    return dioClient.request<void>(
      method: RequestMethod.get,
      EndPoints.forgetPassword,
      queryParams: {"phone": phone},
      fromJson: (json) => (),
    );
  }

  /// This function sends a POST request to reset a password using the provided parameters.
  ///
  /// Args:
  ///   params (ResetPasswordParams): The `resetPassword` method takes a `ResetPasswordParams` object as
  /// a parameter. This object likely contains the necessary information to reset a user's password, such
  /// as the user's email address or username.
  ///
  /// Returns:
  ///   The `resetPassword` method is returning a `Future` that resolves to an `ApiResponse<void>`.
  @override
  Future<ApiResponse<void>> resetPassword(ResetPasswordParams params) async {
    return dioClient.request<void>(
      method: RequestMethod.post,
      EndPoints.resetPassword,
      data: params.toJson(),
      fromJson: (json) => (),
    );
  }

  @override
  /// This function sends a GET request to retrieve a list of cities that belong to the
  /// governorate with the provided `governorateId`.
  ///
  /// Args:
  ///   governorateId (int): The `governorateId` parameter is required to specify which
  /// governorate's cities should be retrieved.
  ///
  /// Returns:
  ///   The `getCities` method is returning a `Future` that resolves to an `ApiResponse`
  /// containing a `List<City>`.
  Future<ApiResponse<List<City>>> getCities(int governorateId) async {
    return dioClient.request<List<City>>(
      method: RequestMethod.get,
      EndPoints.cities(governorateId),
      fromJson: (json) => List<City>.from((json as List).map((city) => City.fromJson(city as Map<String, dynamic>))),
    );
  }

  @override
  /// This function sends a GET request to retrieve a list of countries from the server.
  ///
  /// Returns:
  ///   The `getCountries` method is returning a `Future` that resolves to an `ApiResponse`
  /// containing a `List<Country>`.
  Future<ApiResponse<List<Country>>> getCountries() async {
    return dioClient.request<List<Country>>(
      method: RequestMethod.get,
      EndPoints.countries,
      fromJson:
          (json) =>
              List<Country>.from((json as List).map((country) => Country.fromJson(country as Map<String, dynamic>))),
    );
  }

  @override
  /// This function sends a GET request to retrieve a list of governorates that belong to the
  /// country with the provided `countryId`.
  ///
  /// Args:
  ///   countryId (int): The `countryId` parameter is required to specify which country's
  /// governorates should be retrieved.
  ///
  /// Returns:
  ///   The `getGovernorates` method is returning a `Future` that resolves to an `ApiResponse`
  /// containing a `List<Governorate>`.
  Future<ApiResponse<List<Governorate>>> getGovernorates(int countryId) async {
    return dioClient.request<List<Governorate>>(
      method: RequestMethod.get,
      EndPoints.governorates(countryId),
      fromJson:
          (json) => List<Governorate>.from(
            (json as List).map((governorate) => Governorate.fromJson(governorate as Map<String, dynamic>)),
          ),
    );
  }

  @override
  /// Sends a POST request to verify user registration using the provided parameters.
  ///
  /// Args:
  ///   params (VerifyParams): Contains the necessary details for verification, such as the
  ///   verification code or token.
  ///
  /// Returns:
  ///   A `Future` resolving to an `ApiResponse` containing an `AuthModel` object if successful.
  Future<ApiResponse<AuthModel>> verifyRegistration(VerifyParams params) async {
    return dioClient.request<AuthModel>(
      method: RequestMethod.post,
      EndPoints.verifyRegistration,
      data: params.toJson(),
      fromJson: (json) => AuthModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  /// Resend the OTP for the given phone number.
  ///
  /// Args:
  ///   phone (String): The phone number for which the OTP should be resent.
  ///
  /// Returns:
  ///   A `Future` resolving to an `ApiResponse` containing an empty value if successful.
  Future<ApiResponse<void>> resendOtp(String phone) async {
    return dioClient.request<void>(
      method: RequestMethod.post,
      EndPoints.resendOtp,
      data: {"phone": phone},
      fromJson: (json) => (),
    );
  }

  @override
  Future<ApiResponse<void>> verifyPasswordReset(VerifyParams params) async {
    return dioClient.request<void>(
      method: RequestMethod.post,
      EndPoints.verifyPasswordReset,
      data: params.toJson(),
      fromJson: (json) => (),
    );
  }

  @override
  Future<ApiResponse<void>> deleteAccount(String token) {
    return dioClient.request<void>(
      method: RequestMethod.get,
      EndPoints.deleteAccount,
      options: token.toAuthorizationOptions(),
      fromJson: (json) => (),
    );
  }
}
