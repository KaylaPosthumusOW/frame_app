import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/routes.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';
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

  int _getCurrentIndex() {
    final String? currentRoute = ModalRoute.of(context)?.settings.name;
    switch (currentRoute) {
      case HOME_SCREEN:
        return 0;
      case GALLERY_SCREEN:
        return 1;
      case COMMUNITY_SCREEN:
        return 2;
      case PROFILE_SCREEN:
        return 3;
      default:
        return 0;
    }
  }

  void _onItemTapped(int index) {
    final currentIndex = _getCurrentIndex();
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        context.pushNamed(HOME_SCREEN);
        break;
      case 1:
        context.pushNamed(GALLERY_SCREEN);
        break;
      case 2:
        context.pushNamed(COMMUNITY_SCREEN);
        break;
      case 3:
        context.pushNamed(PROFILE_SCREEN);
        break;
    }
  }

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
              bottomNavigationBar: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.home_rounded), text: 'Home'),
                  Tab(icon: Icon(Icons.image_rounded), text: 'Gallery'),
                  Tab(icon: Icon(Icons.people_rounded), text: 'Community'),
                  Tab(icon: Icon(Icons.person_rounded), text: 'Profile'),
                ],
              ),
            ),
          );
        }
      ),
    );
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
              color: Colors.grey,
              width: 0.5
          ),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.black,
        selectedItemColor: AppColors.framePurple,
        unselectedItemColor: Colors.grey[500],
        selectedFontSize: 14,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedFontSize: 14,
        iconSize: 35,
        currentIndex: _getCurrentIndex(),
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.image_rounded), label: 'Gallery'),
          BottomNavigationBarItem(icon: Icon(Icons.people_rounded), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
