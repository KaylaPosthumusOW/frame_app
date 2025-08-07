import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/cubits/general/general_cubit.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:frameapp/ui/screens/home_screen.dart';
import 'package:frameapp/ui/screens/login/login_screen.dart';
import 'package:frameapp/ui/screens/splash_screen.dart';
import 'package:sp_user_repository/sp_user_repository.dart';

class MainFrameAppScreen extends StatefulWidget {
  const MainFrameAppScreen({super.key});

  @override
  State<MainFrameAppScreen> createState() => _MainFrameAppScreenState();
}

class _MainFrameAppScreenState extends State<MainFrameAppScreen> {
  final AuthenticationCubit _authenticationCubit = sl<AuthenticationCubit>()..appStarted(verifyEmail: false);
  final GeneralCubit _generalCubit = sl<GeneralCubit>();
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeneralCubit, GeneralState>(
      bloc: _generalCubit,
      builder: (context, state) {
        return BlocConsumer<AuthenticationCubit, AuthenticationState>(
          bloc: _authenticationCubit,
          listener: (context, state) {
            if (state is AuthenticationError) {
              _authenticationCubit.reloadUserCache();
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Row(children: [Expanded(child: Text(state.mainAuthenticationState.errorMessage ?? state.mainAuthenticationState.message ?? '', style: const TextStyle(color: Colors.white))), const Icon(Icons.error)]), backgroundColor: Colors.red));
            }
          },
          builder: (context, state) {
            if (state is Uninitialized) {
              return const SplashScreen();
            }

            if (state is Unauthenticated) {
              return const LoginScreen();
            }

            if (state is Authenticated) {
              _appUserProfileCubit.loadProfile();
              return const HomeScreen();
            }

            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          },
        );
      },
    );
  }
}
