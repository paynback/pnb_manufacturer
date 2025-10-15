import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynback_manufacturer_app/controller/repositories/auth_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_event.dart';
part 'splash_state.dart';


class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthStatus authStatus;

  SplashBloc({required this.authStatus}) : super(SplashInitial()) {
    on<CheckLoginStatusEvent>((event, emit) async {
      await Future.delayed(const Duration(seconds: 2));

      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (isLoggedIn) {
        try {
          final response = await authStatus.checkAuthStatus();

          log("API Response in SplashBloc: $response");

          emit(SplashLoggedIn(response));
        } catch (e) {
          log("API Error: $e");
          emit(SplashLoggedOut());
        }
      } else {
        emit(SplashLoggedOut());
      }
    });
  }
}
