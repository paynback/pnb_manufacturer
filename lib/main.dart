import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:paynback_manufacturer_app/constants.dart';
import 'package:paynback_manufacturer_app/controller/repositories/add_kyc.dart';
import 'package:paynback_manufacturer_app/controller/repositories/auth_init.dart';
import 'package:paynback_manufacturer_app/controller/repositories/auth_status.dart';
import 'package:paynback_manufacturer_app/controller/repositories/verify_auth.dart';
import 'package:paynback_manufacturer_app/view/bloc/splash/splash_bloc.dart';
import 'package:paynback_manufacturer_app/view/bloc/submit_kyc/submit_kyc_bloc.dart';
import 'package:paynback_manufacturer_app/view/bloc/submit_phone_number/submit_phone_number_bloc.dart';
import 'package:paynback_manufacturer_app/view/bloc/verify_otp/verify_otp_bloc.dart';
import 'package:paynback_manufacturer_app/view/screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SplashBloc(authStatus: AuthStatus())),
        BlocProvider(create: (_) => SubmitPhoneNumberBloc(authInit: AuthInit())),
        BlocProvider(create: (_) => VerifyOtpBloc(verifyAuth: VerifyAuth())),
        BlocProvider(create: (_) => SubmitKycBloc(addKyc: AddKyc()),),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paynback Manufacturer',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: pnbThemeColor1,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: pnbThemeColor1,
          foregroundColor: pnbwhite,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}