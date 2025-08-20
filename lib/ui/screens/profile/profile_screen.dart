import 'package:flutter/material.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/routes.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:frameapp/cubits/post/post_cubit.dart';
import 'package:frameapp/models/app_user_profile.dart';
import 'package:frameapp/ui/widgets/frame_alert_dialoq.dart';
import 'package:frameapp/ui/widgets/frame_navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_user_repository/sp_user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sp_utilities/utilities.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();
  final AuthenticationCubit _authenticationCubit = sl<AuthenticationCubit>();
  final SPFileUploaderCubit _imageUploaderCubit = sl<SPFileUploaderCubit>();
  final PostCubit _postCubit = sl<PostCubit>();

  String? _downloadUrl;

  @override
  void initState() {
    super.initState();
    _postCubit.loadReportedPosts();
  }

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
            context.pushNamed(LOGIN_SCREEN);
          },
        );
      },
    );
  }

  Widget _buildProfilePicture() {
    return BlocConsumer<SPFileUploaderCubit, SPFileUploaderState>(
      bloc: _imageUploaderCubit,
      listener: (context, state) {
        if (state is SPFileUploaderAllUploadTaskCompleted) {
          _downloadUrl = state.mainSPFileUploadState.downloadUrls?.first;
          if (_appUserProfileCubit.state.mainAppUserProfileState.appUserProfile != null) {
            final AppUserProfile appUserProfile = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile!.copyWith(profilePicture: _downloadUrl);
            _appUserProfileCubit.updateProfile(appUserProfile);
          }
          setState(() {});
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Profile Image Updated', style: TextStyle(color: Colors.white)), Icon(Icons.check, color: Colors.white)]), backgroundColor: Colors.green));
        }
        if (state is SPFileUploaderErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.mainSPFileUploadState.errorMessage ?? state.mainSPFileUploadState.message ?? 'Upload failed'),
          ));
        }
      },
      builder: (context, state) {
        if (state.mainSPFileUploadState.uploadTasks != null && state.mainSPFileUploadState.uploadTasks!.isNotEmpty) {
          return CircleAvatar(
            radius: 100,
            backgroundColor: Colors.grey[300],
            child: const CircularProgressIndicator(color: Colors.white),
          );
        }

        final String? profileUrl = _downloadUrl ?? _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.profilePicture;

        return Stack(
          children: [
            CircleAvatar(
              radius: 100,
              backgroundColor: Colors.grey[300],
              backgroundImage: profileUrl != null && profileUrl.isNotEmpty ? NetworkImage(profileUrl) : const AssetImage('assets/pngs/blank_profile_image.png') as ImageProvider,
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.black,
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () => _addProfilePhoto(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _addProfilePhoto() {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      backgroundColor: AppColors.white,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16, bottom: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.slateGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.framePurple, size: 30),
                title: Text('Take Photo', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black)),
                onTap: () => _updateProfilePicture(cameraFlag: true),
              ),
              Divider(height: 0.5, color: Colors.grey[400]),
              ListTile(
                leading: Icon(Icons.photo_library, color: AppColors.framePurple, size: 30),
                title: Text('Choose from Gallery', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black)),
                onTap: () => _updateProfilePicture(cameraFlag: false),
              ),
              Divider(height: 0.5, color: Colors.grey[400]),
              ListTile(
                leading: Icon(Icons.close, color: AppColors.black, size: 30),
                title: Text('Cancel', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black)),
                onTap: Navigator.of(context).pop,
              ),
            ],
          ),
        );
      },
    );
  }

  _updateProfilePicture({required bool cameraFlag}) async {
    Navigator.of(context).pop();
    Reference storageReference = sl<FirebaseStorage>().ref().child('user').child(_appUserProfileCubit.state.mainAppUserProfileState.appUserProfile!.uid!);
    if (cameraFlag) {
      _imageUploaderCubit.singleSelectImageFromCameraToUploadToReference(storageRef: storageReference);
    } else {
      _imageUploaderCubit.singleSelectImageFromGalleryToUploadToReference(storageRef: storageReference);
    }
  }

  /// ================== Screen Build ==================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () => _logOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              _buildProfilePicture(),
              const SizedBox(height: 30),
              Text(
                '${_appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.name?.isNotEmpty == true ? _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile!.name : 'User'} ${_appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.surname ?? ''}',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.limeGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit, color: Colors.black),
                      title: Text('Edit Profile Data', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black)),
                      onTap: () {
                        context.pushNamed(EDIT_PROFILE_SCREEN);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.notifications, color: Colors.black),
                      title: Text('Notifications', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black)),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings, color: Colors.black),
                      title: Text('Settings', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black)),
                      onTap: () {
                        context.pushNamed(SETTINGS_SCREEN);
                      },
                    ),
                  ],
                ),
              ),
              Offstage(
                offstage: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.role != UserRole.admin,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.lightPink,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text('ADMIN FUNCTIONS', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.black, fontWeight: FontWeight.bold)),
                      ListTile(
                        leading: const Icon(Icons.note_add, color: Colors.black),
                        title: Text('Prompt Management', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black)),
                        onTap: () {
                          context.pushNamed(PROMPT_MANAGEMENT_SCREEN);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.report, color: Colors.black),
                        title: Text('Reported Posts', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black)),
                        onTap: () {
                          context.pushNamed(REPORTED_POSTS_SCREEN);
                        },
                        trailing: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white,
                          child: Text(
                            _postCubit.state.mainPostState.reportedPosts?.length.toString() ?? '0',
                            style: const TextStyle(color: Colors.black, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const FrameNavigation(),
    );
  }
}
