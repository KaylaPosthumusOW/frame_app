import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:frameapp/models/app_user_profile.dart';
import 'package:frameapp/ui/screens/register/register_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frameapp/ui/widgets/frame_text_field.dart';
import 'package:sp_user_repository/sp_user_repository.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final RegisterCubit _registerCubit = sl<RegisterCubit>();
  final AuthenticationCubit _authenticationCubit = sl<AuthenticationCubit>();
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();

  bool _passwordVisible = false;

  bool get isPopulated => _nameController.text.isNotEmpty && _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty && _confirmPasswordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return isPopulated && !state.isInProgress;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      bloc: _registerCubit,
      listener: (context, state) async {
        if (state.isInProgress) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Registering...', style: TextStyle(color: Colors.white)), CircularProgressIndicator(color: Colors.white)])));
        }

        if (state.isSuccess) {
          final user = _authenticationCubit.state.mainAuthenticationState.user;
          if (user != null && user.uid != null) {
            final profile = AppUserProfile(
              uid: user.uid,
              name: _nameController.text.trim(),
              surname: _surnameController.text.trim(),
              email: user.email,
              role: UserRole.user,
              createdAt: Timestamp.now(),
            );
            await _appUserProfileCubit.updateProfile(profile);
            await _appUserProfileCubit.loadProfile();
          }
          Navigator.of(context).pop();
        }

        if (state.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text('Registration Failure\n${state.errorMessage ?? state.message ?? ''}', style: const TextStyle(color: Colors.white))), const Icon(Icons.error)]), backgroundColor: Colors.red));
        }

        if (state is RegisterStatePasswordResetSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Password reset email has been sent', style: TextStyle(color: Colors.white)), Icon(Icons.error)]), backgroundColor: Colors.green));
        }

        if (state is RegisterStateEmailAlreadyExists) {
          _registerCubit.signInFromRegistration(_emailController.text, _passwordController.text);
        }
      },
      child: BlocBuilder<RegisterCubit, RegisterState>(
        bloc: _registerCubit,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 60),
                  Text('Create Your Account!', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.black)),
                  SizedBox(height: 10),
                  FrameTextField(
                    label: 'Name',
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                    isLight: true,
                  ),
                  SizedBox(height: 10),
                  FrameTextField(
                    label: 'Surname',
                    controller: _surnameController,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                    isLight: true,
                  ),
                  SizedBox(height: 10),
                  FrameTextField(
                    label: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => _registerCubit.emailChanged(value),
                    isLight: true,
                  ),
                  SizedBox(height: 10),
                  FrameTextField(
                    label: 'Password',
                    controller: _passwordController,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      child: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                    obscureText: !_passwordVisible,
                    onChanged: (value) => _registerCubit.passwordChanged(value),
                    isLight: true,
                  ),
                  SizedBox(height: 10),
                  FrameTextField(
                    label: 'Confirm Password',
                    controller: _confirmPasswordController,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      child: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                    obscureText: !_passwordVisible,
                    onChanged: (value) => _registerCubit.confirmPasswordChanged(value),
                    isLight: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RegisterButton(onPressed: isRegisterButtonEnabled(state) ? _onFormSubmitted : () {}),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already Have an Account?'),
                            ButtonTheme(
                              minWidth: 220.0,
                              child: TextButton(
                                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Login',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.black,),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
  _nameController.dispose();
  _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onFormSubmitted() {
    _registerCubit.registerSubmitted(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }
}
