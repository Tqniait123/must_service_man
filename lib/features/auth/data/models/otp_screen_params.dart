enum OtpType { register, forgetPassword }

class OtpScreenParams {
  final OtpType otpType;
  final String email;

  OtpScreenParams({required this.otpType, required this.email});
}
