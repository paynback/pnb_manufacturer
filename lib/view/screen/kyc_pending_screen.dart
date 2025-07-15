import 'package:flutter/material.dart';
import 'package:paynback_manufacturer_app/constants.dart';

class KycPendingScreen extends StatelessWidget {
  const KycPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pnbThemeColor2,
      appBar: AppBar(
        title: const Text('KYC Verification'),
        centerTitle: true,
        backgroundColor: pnbThemeColor1,
        foregroundColor: pnbwhite,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration or animation
              Icon(
                Icons.verified_user_rounded,
                size: 100,
                color: pnbThemeColor1,
              ),
              const SizedBox(height: 30),

              // Title
              const Text(
                'KYC is Under Verification',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Message
              const Text(
                'We are currently verifying your details.\nThis process may take a few minutes.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Progress Indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.indigoAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}