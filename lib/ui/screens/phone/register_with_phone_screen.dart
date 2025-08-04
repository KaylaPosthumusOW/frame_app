import 'package:frameapp/ui/screens/phone/register_with_phone_form.dart';
import 'package:flutter/material.dart';

class RegisterWithPhoneScreen extends StatelessWidget {
  final bool linkCredential;

  const RegisterWithPhoneScreen({super.key, this.linkCredential = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register with phone'),
      ),
      body: RegisterWithPhoneForm(linkCredential: linkCredential),
    );
  }
}
