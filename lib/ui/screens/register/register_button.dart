import 'package:flutter/material.dart';
import 'package:frameapp/ui/widgets/frame_button.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback _onPressed;

  RegisterButton({super.key, VoidCallback? onPressed}) : _onPressed = onPressed!;

  @override
  Widget build(BuildContext context) {
    return FrameButton(
      type: ButtonType.primary,
      onPressed: _onPressed,
      label: 'Register',
    );
  }
}
