import 'dart:io';
import 'package:flutter/foundation.dart';

@immutable
abstract class SubmitKycEvent {}

class SubmitKycPressed extends SubmitKycEvent {
  final String name;
  final String email;
  final String aadhaar;
  final String pan;
  final String accountNumber;
  final String ifsc;
  final String branch;
  final File aadhaarFront;
  final File aadhaarBack;
  final File panFront;
  final File panBack;

  SubmitKycPressed({
    required this.name,
    required this.email,
    required this.aadhaar,
    required this.pan,
    required this.accountNumber,
    required this.ifsc,
    required this.branch,
    required this.aadhaarFront,
    required this.aadhaarBack,
    required this.panFront,
    required this.panBack,
  });
}
