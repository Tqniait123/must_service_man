class EndPoints {
  const EndPoints._();
  static const String employerTag = 'employer';

  // Authentication Endpoints
  static const String baseUrl = 'https://must.dev2.tqnia.me/$employerTag/';
  static const String login = 'login';
  static const String loginWithGoogle = 'auth/google/callback';
  static const String loginWithApple = 'login/apple';
  static const String autoLogin = 'profile';
  static const String register = 'register';
  static const String verifyRegistration = 'register/verify_phone';
  static const String verifyPasswordReset = 'check_reset_code';
  static const String resendOtp = 'resend_otp';
  static const String forgetPassword = 'forgot_password';
  static const String resetPassword = 'reset_password';
  static const String home = 'home';
  static const String countries = 'countries';
  static String governorates(int id) => 'governorates/$id';
  static String cities(int id) => 'cities/$id';
  static const String parking = 'parking';
  static const String parkingInUserCity = 'parking_in_user_city';
  static const String faqs = 'faqs';
  static String aboutUs(String lang) => 'about_us';
  static String terms(String lang) => 'terms';
  static String privacyPolicy(String lang) => 'privacy_policy';
  static const String contactUs = 'contact_info';
  static const String currentUsersInParking = 'current_users/parking';
  static String userDetails(int userId) => 'current_users/details/$userId';
  static const String notifications = 'notifications';
  static const String walletWithdraw = 'wallet_withdraw';
  static const String updateProfile = 'update_profile';
}
