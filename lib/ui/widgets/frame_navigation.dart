import 'package:flutter/material.dart';
import 'package:frameapp/constants/themes.dart';

class FrameNavigation extends StatelessWidget {
  const FrameNavigation({super.key});

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
