part of 'submit_phone_number_bloc.dart';

abstract class SubmitPhoneNumberEvent {}

class SubmitPhoneNumberPressed extends SubmitPhoneNumberEvent {
  final String phone;

  SubmitPhoneNumberPressed(this.phone);
}