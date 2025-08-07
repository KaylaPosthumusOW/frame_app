import 'package:flutter/material.dart';
import 'package:frameapp/constants/routes.dart';
import 'package:frameapp/constants/themes.dart';

class FrameNavigation extends StatefulWidget {
  const FrameNavigation({super.key});

  @override
  State<FrameNavigation> createState() => _FrameNavigationState();
}

class _FrameNavigationState extends State<FrameNavigation> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(context, HOME_SCREEN, (route) => false);
        break;
      case 1:
        Navigator.pushNamed(context, GALLERY_SCREEN);
        break;
      case 2:
        Navigator.pushNamed(context, COMMUNITY_SCREEN);
        break;
      case 3:
        Navigator.pushNamed(context, PROFILE_SCREEN);
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
        currentIndex: _currentIndex,
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
