import 'package:flutter/material.dart';
import 'package:frameapp/constants/routes.dart';
import 'package:frameapp/constants/themes.dart';

class FrameNavigation extends StatefulWidget {
  const FrameNavigation({super.key});

  @override
  State<FrameNavigation> createState() => _FrameNavigationState();
}

class _FrameNavigationState extends State<FrameNavigation> {
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
    // Only navigate if we're not already on the selected screen
    final currentIndex = _getCurrentIndex();
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(context, HOME_SCREEN, (route) => false);
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(context, GALLERY_SCREEN, (route) => false);
        break;
      case 2:
        Navigator.pushNamedAndRemoveUntil(context, COMMUNITY_SCREEN, (route) => false);
        break;
      case 3:
        Navigator.pushNamedAndRemoveUntil(context, PROFILE_SCREEN, (route) => false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
              color: Colors.white,
              width: 0.5
          ),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.black,
        selectedItemColor: AppColors.lightPink,
        unselectedItemColor: AppColors.white,
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
