enum OtpType { register, forgetPassword }

class OtpScreenParams {
  final OtpType otpType;
  final String phone;

  OtpScreenParams({required this.otpType, required this.phone});
}
