import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/routes.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:frameapp/cubits/post/post_cubit.dart';
import 'package:frameapp/ui/screens/community_screen.dart';
import 'package:frameapp/ui/screens/gallery_screen.dart';
import 'package:frameapp/ui/screens/home_screen.dart';
import 'package:frameapp/ui/screens/onboarding_screens.dart';
import 'package:frameapp/ui/screens/profile/profile_screen.dart';
import 'package:go_router/go_router.dart';

class FrameNavigation extends StatefulWidget {
  const FrameNavigation({super.key});

  @override
  State<FrameNavigation> createState() => _FrameNavigationState();
}

class _FrameNavigationState extends State<FrameNavigation> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>()..loadProfile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppUserProfileCubit, AppUserProfileState>(
        bloc: _appUserProfileCubit,
        builder: (context, state) {
          if (state.mainAppUserProfileState.appUserProfile != null && !state.mainAppUserProfileState.appUserProfile!.hasSeenOnboarding) {
            return const OnboardingScreen();
          }

          return DefaultTabController(
            length: 4,
            child: Scaffold(
              body: const TabBarView(
                children: [
                  HomeScreen(),
                  GalleryScreen(),
                  CommunityScreen(),
                  ProfileScreen(),
                ],
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: AppColors.black,
                  border: Border(top: BorderSide(color: AppColors.white, width: 0.5)),
                ),
                child: TabBar(
                  labelColor: AppColors.framePurple,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(icon: Icon(Icons.home_rounded), text: 'Home'),
                    Tab(icon: Icon(Icons.image_rounded), text: 'Gallery'),
                    Tab(icon: Icon(Icons.people_rounded), text: 'Community'),
                    Tab(icon: Icon(Icons.person_rounded), text: 'Profile'),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
