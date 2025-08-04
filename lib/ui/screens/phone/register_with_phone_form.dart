import 'package:frameapp/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:sp_user_repository/sp_user_repository.dart';

class RegisterWithPhoneForm extends StatefulWidget {
  final bool linkCredential;

  const RegisterWithPhoneForm({super.key, this.linkCredential = false});

  @override
  RegisterWithPhoneFormState createState() => RegisterWithPhoneFormState();
}

class RegisterWithPhoneFormState extends State<RegisterWithPhoneForm> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final RegisterPhoneCubit _registerPhoneCubit = sl<RegisterPhoneCubit>();
  String _phoneNumber = '';

  _mobileNumberInput() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: BlocBuilder<RegisterPhoneCubit, RegisterPhoneState>(
        bloc: _registerPhoneCubit,
        builder: (context, state) {
          return ListView(
            children: [
              IntlPhoneField(
                controller: _inputController,
                initialCountryCode: 'ZA',
                onChanged: (PhoneNumber phone) {
                  _phoneNumber = phone.completeNumber;
                  _registerPhoneCubit.registerPhoneNumberChanged(_phoneNumber);
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.phone_iphone),
                  labelText: 'Phone number',
                ),
                keyboardType: TextInputType.phone,
                keyboardAppearance: Brightness.dark,
                validator: (_) => !state.isPhoneValid ? 'Invalid Phone number' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                onPressed: () => _registerPhoneCubit.registerPhoneSubmitted(phone: _phoneNumber, linkCredential: widget.linkCredential),
                child: const Text('SUBMIT'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                onPressed: () => _registerPhoneCubit.registerPhoneSubmittedOTPRequest(phoneNumber: _phoneNumber),
                child: const Text('SUBMIT OTP REQUEST'),
              ),
            ],
          );
        },
      ),
    );
  }

  _otpInput() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: BlocBuilder<RegisterPhoneCubit, RegisterPhoneState>(
        bloc: _registerPhoneCubit,
        builder: (context, state) {
          return ListView(
            children: [
              TextFormField(
                controller: _otpController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.phone_iphone),
                  labelText: 'OTP',
                ),
                keyboardAppearance: Brightness.dark,
                keyboardType: TextInputType.number,
                validator: (_) => !state.isOTPValid ? 'Invalid OTP' : null,
                onChanged: (value) => _registerPhoneCubit.registerPhoneOTPChanged(_otpController.text),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                onPressed: () => _registerPhoneCubit.registerOTPSubmitted(otp: _otpController.text, linkCredential: widget.linkCredential),
                child: const Text('SUBMIT'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                onPressed: () => _registerPhoneCubit.verifyOTP(phoneNumber: _phoneNumber, otp: _otpController.text, functionUrl: 'https://us-central1-spaza-internal-poc.cloudfunctions.net/createUserWithPhoneNumber'),
                child: const Text('SUBMIT OTP REQUEST'),
              ),
              const SizedBox(height: 16),
              TextButton(
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                onPressed: () => _registerPhoneCubit.resendOtpRequest(phoneNumber: _phoneNumber, functionUrl: 'https://us-central1-spaza-internal-poc.cloudfunctions.net/resendOtpRequest'),
                child: const Text('Resend OTP'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterPhoneCubit, RegisterPhoneState>(
      bloc: _registerPhoneCubit,
      listener: (context, state) {
        if (state.isSubmitting) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Registering with phone...', style: TextStyle(color: Colors.white)), CircularProgressIndicator(color: Colors.white)])));
        }

        if (state.isSuccess) {
          Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
        }

        if (state.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text('Phone Registration Failure\n${state.errorMessage ?? state.message}')), const Icon(Icons.error)]),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<RegisterPhoneCubit, RegisterPhoneState>(
        bloc: _registerPhoneCubit,
        builder: (context, state) {
          if (state.verificationId != null) {
            return _otpInput();
          }

          return _mobileNumberInput();
        },
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}
