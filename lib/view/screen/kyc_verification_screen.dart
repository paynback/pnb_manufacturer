import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paynback_manufacturer_app/constants.dart';
import 'package:paynback_manufacturer_app/view/bloc/submit_kyc/submit_kyc_bloc.dart';
import 'package:paynback_manufacturer_app/view/bloc/submit_kyc/submit_kyc_event.dart';
import 'package:paynback_manufacturer_app/view/bloc/submit_kyc/submit_kyc_state.dart';
import 'package:paynback_manufacturer_app/view/screen/kyc_pending_screen.dart';

class KycVerificationScreen extends StatefulWidget {
  const KycVerificationScreen({super.key});

  @override
  State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();

  File? _aadhaarFront;
  File? _aadhaarBack;
  File? _panFront;
  File? _panBack;

  Future<void> _pickImage(bool isAadhaar, bool isFront) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (isAadhaar) {
          isFront ? _aadhaarFront = File(picked.path) : _aadhaarBack = File(picked.path);
        } else {
          isFront ? _panFront = File(picked.path) : _panBack = File(picked.path);
        }
      });
    }
  }

  void _submitKyc() {
    if (_formKey.currentState!.validate()) {
      if (_aadhaarFront == null || _aadhaarBack == null || _panFront == null || _panBack == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload all required documents')),
        );
        return;
      }

      context.read<SubmitKycBloc>().add(SubmitKycPressed(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        aadhaar: _aadhaarController.text.trim(),
        pan: _panController.text.trim(),
        accountNumber: _accountNumberController.text.trim(),
        ifsc: _ifscController.text.trim(),
        branch: _branchController.text.trim(),
        aadhaarFront: _aadhaarFront!,
        aadhaarBack: _aadhaarBack!,
        panFront: _panFront!,
        panBack: _panBack!,
      ));
    }
  }

  Widget _buildImagePicker(String label, File? file, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            ),
            child: file != null
                ? Image.file(file, fit: BoxFit.cover)
                : const Center(child: Text('Tap to upload')),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _aadhaarController.dispose();
    _panController.dispose();
    _accountNumberController.dispose();
    _ifscController.dispose();
    _branchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubmitKycBloc, SubmitKycState>(
      listener: (context, state) {
        if (state is SubmitKycLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else {
          Navigator.of(context, rootNavigator: true).pop();
        }
    
        if (state is SubmitKycSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const KycPendingScreen()),
            (route) => false,
          );
        } else if (state is SubmitKycFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: pnbThemeColor2,
        appBar: AppBar(
          title: const Text('KYC Verification'),
          backgroundColor: pnbThemeColor1,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (value) => value!.isEmpty ? 'Enter name' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) => value!.isEmpty ? 'Enter email' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _aadhaarController,
                  decoration: const InputDecoration(labelText: 'Aadhaar Number'),
                  keyboardType: TextInputType.number,
                  maxLength: 12,
                  validator: (value) =>
                      value!.length != 12 ? 'Enter 12-digit Aadhaar number' : null,
                ),
                _buildImagePicker('Aadhaar Front', _aadhaarFront, () => _pickImage(true, true)),
                _buildImagePicker('Aadhaar Back', _aadhaarBack, () => _pickImage(true, false)),
                TextFormField(
                  textCapitalization: TextCapitalization.characters,
                  controller: _panController,
                  decoration: const InputDecoration(labelText: 'PAN Number'),
                  validator: (value) => value!.isEmpty ? 'Enter PAN number' : null,
                ),
                _buildImagePicker('PAN Front', _panFront, () => _pickImage(false, true)),
                _buildImagePicker('PAN Back', _panBack, () => _pickImage(false, false)),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _accountNumberController,
                  decoration: const InputDecoration(labelText: 'Account Number'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter account number' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _ifscController,
                  decoration: const InputDecoration(labelText: 'IFSC Code'),
                  validator: (value) => value!.isEmpty ? 'Enter IFSC code' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: _branchController,
                  decoration: const InputDecoration(labelText: 'Branch'),
                  validator: (value) => value!.isEmpty ? 'Enter branch name' : null,
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _submitKyc(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pnbThemeColor1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Submit KYC',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
