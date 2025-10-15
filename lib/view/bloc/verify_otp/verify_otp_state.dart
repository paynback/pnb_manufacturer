abstract class VerifyOtpState {}

class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpLoading extends VerifyOtpState {}

class VerifyOtpSuccess extends VerifyOtpState {
  final bool isKyc;
  final bool isVerified;
  final String manufacturerName;

  VerifyOtpSuccess({required this.isKyc, required this.isVerified,required this.manufacturerName});
}

class VerifyOtpFailure extends VerifyOtpState {
  final String message;
  VerifyOtpFailure(this.message);
}
