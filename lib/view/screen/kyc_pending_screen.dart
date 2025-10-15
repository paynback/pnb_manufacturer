import 'package:flutter/material.dart';
import 'package:paynback_manufacturer_app/constants.dart';

class KycPendingScreen extends StatelessWidget {
  const KycPendingScreen({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1)); // Optional delay
    // Restart the app by navigating to the initial route
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

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
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.85, // so pull-to-refresh works
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.verified_user_rounded,
                    size: 100,
                    color: pnbThemeColor1,
                  ),
                  const SizedBox(height: 30),

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

                  const Text(
                    'We are currently verifying your details.\nThis process may take a few minutes.\nPlease check back after a few minutes.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}