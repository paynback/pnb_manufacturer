import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynback_manufacturer_app/constants.dart';
import 'package:paynback_manufacturer_app/view/home_page_screen.dart';
import 'package:paynback_manufacturer_app/view/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyHomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pnbThemeColor2,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('asset/image/PayNback Logo-01 1.png',),)
                ),
              ),
              SizedBox(height: 100,),
              Text('Manufacturer',style: GoogleFonts.poppins(fontSize: 25,fontWeight: FontWeight.w500),)
            ],
          ),
        ),
      ),
    );
  }
}