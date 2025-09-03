enum OtpFlow { passwordReset, registration, login }

class OtpScreenParams {
  final OtpFlow otpFlow;
  final String phone;

  OtpScreenParams({required this.otpFlow, required this.phone});
}
