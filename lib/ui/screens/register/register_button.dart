import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback _onPressed;

  RegisterButton({super.key, VoidCallback? onPressed}) : _onPressed = onPressed!;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
      onPressed: _onPressed,
      child: const Text('Register'),
    );
  }
}
