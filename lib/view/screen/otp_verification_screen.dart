import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynback_manufacturer_app/constants.dart';
import 'package:paynback_manufacturer_app/view/bloc/verify_otp/verify_otp_bloc.dart';
import 'package:paynback_manufacturer_app/view/bloc/verify_otp/verify_otp_event.dart';
import 'package:paynback_manufacturer_app/view/bloc/verify_otp/verify_otp_state.dart';
import 'package:paynback_manufacturer_app/view/screen/home_page_screen.dart';
import 'package:paynback_manufacturer_app/view/screen/kyc_pending_screen.dart';
import 'package:paynback_manufacturer_app/view/screen/kyc_verification_screen.dart';
import 'package:paynback_manufacturer_app/view/screen/login_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phone;

  const OtpVerificationScreen({super.key, required this.phone});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  void _submitOtp() {
    final otp = _otpController.text.trim();
    if (otp.length == 6) {
      context.read<VerifyOtpBloc>().add(
            SubmitOtpEvent(phone: widget.phone, otp: otp),
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
    }
  }

  void _resendOtp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP resent')),
    );
  }

  void _changePhoneNumber() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pnbThemeColor2,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
          listener: (context, state) async {
            if (state is VerifyOtpSuccess) {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', true);

              if (state.isKyc == false) {
                // Navigate to KYC Verification Screen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const KycVerificationScreen()),
                  (Route<dynamic> route) => false,
                );
              } else if (state.isKyc == true && state.isVerified == false) {
                // Navigate to KYC Pending Screen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const KycPendingScreen()),
                  (Route<dynamic> route) => false,
                );
              } else if (state.isKyc == true && state.isVerified == true) {
                // Navigate to Home Screen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MyHomePage()),
                  (Route<dynamic> route) => false,
                );
              }
            } else if (state is VerifyOtpFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Enter OTP sent to +91-${widget.phone}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: pnbThemeColor1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  PinCodeTextField(
                    appContext: context,
                    controller: _otpController,
                    length: 6,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.fade,
                    cursorColor: Colors.green,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeColor: pnbThemeColor1,
                      selectedColor: pnbThemeColor1,
                      inactiveColor: Colors.grey,
                    ),
                    onChanged: (_) {},
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: state is VerifyOtpLoading ? null : _submitOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pnbThemeColor1,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: state is VerifyOtpLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Submit OTP', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 10),
                  TextButton(onPressed: _resendOtp, child: const Text('Resend OTP')),
                  TextButton(onPressed: _changePhoneNumber, child: const Text('Change Phone Number')),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}