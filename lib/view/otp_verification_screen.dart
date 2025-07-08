import 'package:flutter/material.dart';
import 'package:paynback_manufacturer_app/constants.dart';
import 'package:paynback_manufacturer_app/view/kyc_verification_screen.dart';
import 'package:paynback_manufacturer_app/view/login_screen.dart';
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

  Future<void> _submitOtp() async {
    if (_otpController.text.length == 6) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const KycVerificationScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
    }
  }

  void _resendOtp() {
    // Implement actual resend OTP logic here.
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
        child: Center(
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
                onChanged: (value) {},
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: pnbThemeColor1,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Submit OTP', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _resendOtp,
                child: const Text('Resend OTP'),
              ),
              TextButton(
                onPressed: _changePhoneNumber,
                child: const Text('Change Phone Number'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}