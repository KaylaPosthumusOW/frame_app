import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/cubits/general/general_cubit.dart';
import 'package:frameapp/ui/screens/home_screen.dart';
import 'package:frameapp/ui/screens/login/login_screen.dart';
import 'package:frameapp/ui/screens/splash_screen.dart';
import 'package:sp_user_repository/sp_user_repository.dart';
import 'package:sp_utilities/utilities.dart';

class MinFrameAppScreem extends StatefulWidget {
  const MinFrameAppScreem({super.key});

  @override
  State<MinFrameAppScreem> createState() => _MinFrameAppScreemState();
}

class _MinFrameAppScreemState extends State<MinFrameAppScreem> {
  final AuthenticationCubit _authenticationCubit = sl<AuthenticationCubit>()..appStarted(verifyEmail: false);
  final GeneralCubit _generalCubit = sl<GeneralCubit>();

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
            if (state is Authenticated) {
              DiscordLogging.initializeDiscord(
                userId: state.mainAuthenticationState.user!.uid!,
                userDisplayName: state.mainAuthenticationState.user?.displayName ?? state.mainAuthenticationState.user?.name ?? state.mainAuthenticationState.user?.email ?? '',
                kDiscordDebugWebhookURL: 'https://discord.com/api/webhooks/1394305360722137320/5lPPQMXgiUKc_ZzmMjTOIW8c-F3U9tKVs5Vq-D2XBRDJ7YZFHb1K3aSM8KvF6c0DnSEk',
                kDiscordReleaseWebhookURL: 'https://discord.com/api/webhooks/1394305360722137320/5lPPQMXgiUKc_ZzmMjTOIW8c-F3U9tKVs5Vq-D2XBRDJ7YZFHb1K3aSM8KvF6c0DnSEk',
              );
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
              return const HomeScreen();
            }

            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          },
        );
      },
    );
  }
}
