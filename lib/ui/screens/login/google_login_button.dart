import 'package:frameapp/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:sp_user_repository/sp_user_repository.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 220.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.black.withValues(alpha: 0.5), width: 2.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: IconButton(
          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
          icon: Icon(FontAwesomeIcons.google, color: AppColors.black,),
          onPressed: () => sl<LoginCubit>().loginWithGooglePressed(),
        ),
      ),
    );
  }
}
