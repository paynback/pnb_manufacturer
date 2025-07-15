import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynback_manufacturer_app/controller/repositories/auth_init.dart';

part 'submit_phone_number_event.dart';
part 'submit_phone_number_state.dart';

class SubmitPhoneNumberBloc extends Bloc<SubmitPhoneNumberEvent, SubmitPhoneNumberState> {
  final AuthInit authInit;

  SubmitPhoneNumberBloc({required this.authInit}) : super(SubmitPhoneNumberInitial()) {
    on<SubmitPhoneNumberPressed>((event, emit) async {
      emit(SubmitPhoneNumberLoading());
      try {
        await authInit.initiateAuth(event.phone);
        emit(SubmitPhoneNumberSuccess());
      } catch (e) {
        String message;
        if (e is DioException) {
          message = e.response?.data['message'] ?? 'Network error occurred';
        } else if (e is Exception) {
          message = e.toString().replaceFirst('Exception: ', '');
        } else {
          message = 'Something went wrong';
        }
        emit(SubmitPhoneNumberFailure(message));
      }
    });
  }
}