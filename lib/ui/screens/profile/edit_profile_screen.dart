import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();
  
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _phoneController;
  
  @override
  void initState() {
    super.initState();
    final profile = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _surnameController = TextEditingController(text: profile?.surname ?? '');
    _phoneController = TextEditingController(text: profile?.phoneNumber ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: BlocListener<AppUserProfileCubit, AppUserProfileState>(
        bloc: _appUserProfileCubit,
        listener: (context, state) {
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.mainAppUserProfileState.errorMessage}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  icon: Icon(Icons.person),
                ),
                keyboardAppearance: Brightness.dark,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _surnameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  icon: Icon(Icons.person_outline),
                ),
                keyboardAppearance: Brightness.dark,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  icon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                keyboardAppearance: Brightness.dark,
              ),
              const SizedBox(height: 32),
              BlocBuilder<AppUserProfileCubit, AppUserProfileState>(
                bloc: _appUserProfileCubit,
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is ProfileUpdating ? null : _saveProfile,
                    child: state is ProfileUpdating
                        ? const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              SizedBox(width: 8),
                              Text('Saving...'),
                            ],
                          )
                        : const Text('Save Changes'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() {
    final currentProfile = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile;
    if (currentProfile != null) {
      final updatedProfile = currentProfile.copyWith(
        name: _nameController.text.trim(),
        surname: _surnameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
      );
      _appUserProfileCubit.updateProfile(updatedProfile);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
