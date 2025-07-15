part of 'splash_bloc.dart';

abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoggedIn extends SplashState {
  final Map<String, dynamic> authData;

  SplashLoggedIn(this.authData);
}

class SplashLoggedOut extends SplashState {}