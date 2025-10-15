import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynback_manufacturer_app/constants.dart';
import 'package:paynback_manufacturer_app/view/bloc/submit_phone_number/submit_phone_number_bloc.dart';
import 'package:paynback_manufacturer_app/view/screen/otp_verification_screen.dart';

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
      context.read<SubmitPhoneNumberBloc>().add(SubmitPhoneNumberPressed(phone));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid 10-digit phone number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pnbwhite,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: BlocConsumer<SubmitPhoneNumberBloc, SubmitPhoneNumberState>(
            listener: (context, state) {
              if (state is SubmitPhoneNumberFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is SubmitPhoneNumberSuccess) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OtpVerificationScreen(
                      phone: _phoneController.text.trim(),
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Column(
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
                    child: state is SubmitPhoneNumberLoading
                      ? Center(child: const CircularProgressIndicator())
                      : const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}