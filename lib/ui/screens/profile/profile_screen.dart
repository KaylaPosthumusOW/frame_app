import 'package:flutter/material.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/ui/widgets/frame_navigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Widget _buildProfilePicture() {
    return CircleAvatar(
      radius: 120,
      backgroundImage: AssetImage('assets/pngs/blank_profile_image.png'),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            Stack(
              children: [
                _buildProfilePicture(),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.limeGreen,
                    child: IconButton(
                      icon: Icon(Icons.edit, color: AppColors.black),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'Name Surname',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white),
            ),
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.lightPink,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: Icon(Icons.edit, color: AppColors.black),
                    title: Text('Edit Profile Data', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.black)),
                    onTap: () {
                      Navigator.pushNamed(context, '/profile/edit');
                    }
                  ),
                  ListTile(
                      leading: Icon(Icons.notifications, color: AppColors.black),
                      title: Text('Notifications', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.black)),
                      onTap: () {}
                  ),
                  ListTile(
                      leading: Icon(Icons.settings, color: AppColors.black),
                      title: Text('Settings', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.black)),
                      onTap: () {
                        Navigator.pushNamed(context, '/settings');
                      }
                  ),
                ]
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: FrameNavigation(),
    );
  }
}
