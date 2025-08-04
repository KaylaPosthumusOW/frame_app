import 'package:frameapp/ui/screens/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateAccountButton extends StatelessWidget {
  const CreateAccountButton({super.key});

  _goToRegisterScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 220.0,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
        icon: const Icon(FontAwesomeIcons.plus),
        onPressed: () => _goToRegisterScreen(context),
        label: const Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Text('Register a new account'),
        ),
      ),
    );
  }
}
