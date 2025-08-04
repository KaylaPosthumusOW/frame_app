import 'package:frameapp/ui/screens/phone/register_with_phone_screen.dart';
import 'package:flutter/material.dart';

class PhoneLoginButton extends StatelessWidget {
  const PhoneLoginButton({super.key});

  _navigateToRegisterWithPhone(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterWithPhoneScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
      icon: const Icon(Icons.phone_iphone),
      onPressed: () => _navigateToRegisterWithPhone(context),
      label: const Text('Sign in with Phone'),
    );
  }
}
