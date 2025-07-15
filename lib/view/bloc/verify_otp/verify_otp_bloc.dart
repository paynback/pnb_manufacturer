import 'package:bloc/bloc.dart';
import 'package:paynback_manufacturer_app/controller/repositories/verify_auth.dart';
import 'package:paynback_manufacturer_app/view/bloc/verify_otp/verify_otp_event.dart';
import 'package:paynback_manufacturer_app/view/bloc/verify_otp/verify_otp_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyAuth verifyAuth;

  VerifyOtpBloc({required this.verifyAuth}) : super(VerifyOtpInitial()) {
    on<SubmitOtpEvent>((event, emit) async {
      emit(VerifyOtpLoading());
      try {
        final response = await verifyAuth.verifyOtp(event.phone, event.otp);
        final isKyc = response['isKyc'] as bool;
        final isVerified = response['isVerified'] as bool;
        final manufacturerId = response['manufacturer_id'] as String;

         // Save manufacturer_id to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('manufacturer_id', manufacturerId);

        emit(VerifyOtpSuccess(isKyc: isKyc, isVerified: isVerified));
      } catch (e) {
        emit(VerifyOtpFailure(e.toString().replaceFirst('Exception: ', '')));
      }
    });
  }
}
