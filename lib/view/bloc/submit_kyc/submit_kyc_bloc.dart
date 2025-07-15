import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynback_manufacturer_app/controller/repositories/add_kyc.dart';
import 'submit_kyc_event.dart';
import 'submit_kyc_state.dart';

class SubmitKycBloc extends Bloc<SubmitKycEvent, SubmitKycState> {
  final AddKyc addKyc;

  SubmitKycBloc({required this.addKyc}) : super(SubmitKycInitial()) {
    on<SubmitKycPressed>((event, emit) async {
      emit(SubmitKycLoading());
      try {
        final response = await addKyc.submitKyc(
          name: event.name,
          email: event.email,
          aadhaar: event.aadhaar,
          pan: event.pan,
          accountNumber: event.accountNumber,
          ifsc: event.ifsc,
          branch: event.branch,
          aadhaarFront: event.aadhaarFront,
          aadhaarBack: event.aadhaarBack,
          panFront: event.panFront,
          panBack: event.panBack,
        );
        emit(SubmitKycSuccess(response.data['message'] ?? 'KYC submitted successfully'));
      } catch (e) {
        emit(SubmitKycFailure(e.toString()));
      }
    });
  }
}
