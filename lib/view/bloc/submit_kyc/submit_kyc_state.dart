import 'package:flutter/foundation.dart';

@immutable
abstract class SubmitKycState {}

class SubmitKycInitial extends SubmitKycState {}

class SubmitKycLoading extends SubmitKycState {}

class SubmitKycSuccess extends SubmitKycState {
  final String message;
  SubmitKycSuccess(this.message);
}

class SubmitKycFailure extends SubmitKycState {
  final String error;
  SubmitKycFailure(this.error);
}
