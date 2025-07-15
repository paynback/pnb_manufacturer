abstract class VerifyOtpEvent {}

class SubmitOtpEvent extends VerifyOtpEvent {
  final String phone;
  final String otp;

  SubmitOtpEvent({required this.phone, required this.otp});
}