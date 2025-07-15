import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynback_manufacturer_app/constants.dart';
import 'package:paynback_manufacturer_app/view/bloc/splash/splash_bloc.dart';
import 'package:paynback_manufacturer_app/view/screen/home_page_screen.dart';
import 'package:paynback_manufacturer_app/view/screen/kyc_pending_screen.dart';
import 'package:paynback_manufacturer_app/view/screen/kyc_verification_screen.dart';
import 'package:paynback_manufacturer_app/view/screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(CheckLoginStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pnbThemeColor2,
      body: SafeArea(
        child: BlocListener<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state is SplashLoggedIn) {
              final authData = state.authData;
              final isKyc = authData['isKyc'] == true;
              final isVerified = authData['isVerified'] == true;

              if (isKyc && isVerified) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MyHomePage()),
                );
              } else if (isKyc && !isVerified) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const KycPendingScreen()),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const KycVerificationScreen()),
                );
              }
            } else if (state is SplashLoggedOut) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            }
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  width: double.maxFinite,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('asset/image/PayNback Logo-01 1.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                Text(
                  'Manufacturer',
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}