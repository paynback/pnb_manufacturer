import 'package:flutter/material.dart';
import 'package:paynback_manufacturer_app/constants.dart';
import 'package:paynback_manufacturer_app/view/otp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  void _submitPhoneNumber() {
    final phone = _phoneController.text.trim();
    if (phone.length == 10) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OtpVerificationScreen(phone: phone)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid 10-digit phone number')),
      );
    }
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
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: pnbThemeColor1,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                maxLength: 10,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitPhoneNumber,
                style: ElevatedButton.styleFrom(
                  backgroundColor: pnbThemeColor1,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Submit', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}