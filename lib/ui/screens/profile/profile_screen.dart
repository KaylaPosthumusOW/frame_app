import 'package:flutter/material.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:frameapp/models/app_user_profile.dart';
import 'package:frameapp/ui/widgets/frame_alert_dialoq.dart';
import 'package:frameapp/ui/widgets/frame_navigation.dart';
import 'package:sp_user_repository/sp_user_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();
  final AuthenticationCubit _authenticationCubit = sl<AuthenticationCubit>();

  _logOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FrameAlertDialoq(
          title: 'Log Out!',
          actionTitle: 'Yes',
          content: 'Are you sure you want to log out of this profile?',
          action: () {
            _authenticationCubit.loggedOut(clearPreferences: true);
            Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
          },
        );
      },
    );
  }

  Widget _buildProfilePicture() {
    return CircleAvatar(
      radius: 100,
      backgroundImage: AssetImage('assets/pngs/blank_profile_image.png'),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: AppColors.white),
            onPressed: () => _logOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30),
              Stack(
                children: [
                  _buildProfilePicture(),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.white,
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
                '${_appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.name?.isNotEmpty == true ? _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile!.name : 'User'} ${_appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.surname ?? ''}',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.black),
              ),
              SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
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
              ),
              Offstage(
                offstage: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.role != UserRole.admin,
                child: Container(
                  margin: EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.limeGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('ADMIN FUNCTIONS', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.black, fontWeight: FontWeight.bold)),
                        ListTile(
                            leading: Icon(Icons.note_add, color: AppColors.black),
                            title: Text('Prompt Management', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.black)),
                            onTap: () {
                              Navigator.pushNamed(context, '/admin/prompt_management');
                            }
                        ),
                        ListTile(
                            leading: Icon(Icons.report, color: AppColors.black),
                            title: Text('Reported Posts', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.black)),
                            onTap: () {
                              Navigator.pushNamed(context, '/admin/reported_posts');
                            }
                        ),
                      ]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: FrameNavigation(),
    );
  }
}
