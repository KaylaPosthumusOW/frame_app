import 'package:flutter/material.dart';
import 'package:frameapp/ui/widgets/frame_button.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback _onPressed;

  LoginButton({super.key, VoidCallback? onPressed}) : _onPressed = onPressed!;

  @override
  Widget build(BuildContext context) {
    return FrameButton(
      type: ButtonType.secondary,
      label: 'Login',
      onPressed: _onPressed,
    );
  }
}
