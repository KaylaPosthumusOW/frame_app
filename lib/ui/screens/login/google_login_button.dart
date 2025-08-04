import 'package:frameapp/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sp_user_repository/sp_user_repository.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 220.0,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
        icon: const Icon(FontAwesomeIcons.google),
        onPressed: () => sl<LoginCubit>().loginWithGooglePressed(),
        label: const Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}
