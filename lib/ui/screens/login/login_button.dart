import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback _onPressed;

  LoginButton({super.key, VoidCallback? onPressed}) : _onPressed = onPressed!;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
      onPressed: _onPressed,
      child: const Text('Login'),
    );
  }
}
