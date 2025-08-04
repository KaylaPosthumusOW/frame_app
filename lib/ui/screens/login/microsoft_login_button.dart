import 'package:frameapp/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sp_user_repository/sp_user_repository.dart';

class MicrosoftLoginButton extends StatelessWidget {
  const MicrosoftLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 220.0,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
        icon: const Icon(FontAwesomeIcons.microsoft),
        onPressed: () => sl<LoginCubit>().loginWithMicrosoftPressed(),
        label: const Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Text('Sign in with Microsoft'),
        ),
      ),
    );
  }
}
