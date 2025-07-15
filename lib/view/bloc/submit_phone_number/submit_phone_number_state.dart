part of 'submit_phone_number_bloc.dart';

abstract class SubmitPhoneNumberState {}

class SubmitPhoneNumberInitial extends SubmitPhoneNumberState {}

class SubmitPhoneNumberLoading extends SubmitPhoneNumberState {}

class SubmitPhoneNumberSuccess extends SubmitPhoneNumberState {}

class SubmitPhoneNumberFailure extends SubmitPhoneNumberState {
  final String message;

  SubmitPhoneNumberFailure(this.message);
}