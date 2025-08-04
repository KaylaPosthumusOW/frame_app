import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/ui/screens/login/anon_button.dart';
import 'package:frameapp/ui/screens/login/apple_login_button.dart';
import 'package:frameapp/ui/screens/login/create_account_button.dart';
import 'package:frameapp/ui/screens/login/google_login_button.dart';
import 'package:frameapp/ui/screens/login/login_button.dart';
import 'package:frameapp/ui/screens/login/microsoft_login_button.dart';
import 'package:frameapp/ui/screens/login/phone_login_button.dart';
import 'package:frameapp/ui/screens/register/forgot_password_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_user_repository/sp_user_repository.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _textFieldController = TextEditingController();

  final LoginCubit _loginCubit = sl<LoginCubit>();
  final MultifactorAuthenticationCubit _multifactorAuthenticationCubit = sl<MultifactorAuthenticationCubit>();

  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  String _hint = '';
  FirebaseAuthMultiFactorException? _e;
  bool _passwordVisible = false;

  bool isLoginButtonEnabled(LoginState state) {
    return isPopulated && !state.isInProgress;
  }

  _showOTPInputPopup(String info, FirebaseAuthMultiFactorException? e) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter OTP sent to $info'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: "OTP"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );

    if (_textFieldController.text.isNotEmpty) {
      _multifactorAuthenticationCubit.mfaOTPSubmitted(otp: _textFieldController.text, signIn: true, e: e!);
      _textFieldController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          bloc: _loginCubit,
          listener: (context, state) async {
            if (state.isFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Row(children: [Expanded(child: Text(state.errorMessage ?? state.message ?? '', style: const TextStyle(color: Colors.white))), const Icon(Icons.error)]), backgroundColor: Colors.red));
            }

            if (state.isInProgress) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Logging In...', style: TextStyle(color: Colors.white)),
                          CircularProgressIndicator(color: Colors.white),
                        ],
                      ),
                      backgroundColor: Colors.black),
                );
            }

            if (state.isSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(content: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Logged in successfully', style: TextStyle(color: Colors.white)), Icon(Icons.error, color: Colors.white)]), backgroundColor: Colors.green));
            }

            if (state is LoginStatePasswordResetSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(content: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Password reset email has been sent', style: TextStyle(color: Colors.white)), Icon(Icons.error)]), backgroundColor: Colors.green));
            }

            if (state is LoginRequiresMFA) {
              _hint = state.hint.phoneNumber;
              _e = state.error;
              _multifactorAuthenticationCubit.signInMFA(state.session, state.hint);
            }
          },
        ),
        BlocListener<MultifactorAuthenticationCubit, MultifactorAuthenticationState>(
          bloc: _multifactorAuthenticationCubit,
          listener: (context, state) {
            if (state is MFAPhoneOTPRequired) {
              _showOTPInputPopup(_hint, _e);
            }
          },
        ),
      ],
      child: BlocBuilder<LoginCubit, LoginState>(
        bloc: _loginCubit,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.email),
                      labelText: 'Email',
                      errorText: state.emailError ? 'Invalid email' : null,
                    ),
                    keyboardAppearance: Brightness.dark,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => _loginCubit.emailChanged(value),
                  ),
                  TextFormField(
                    keyboardAppearance: Brightness.dark,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock),
                      labelText: 'Password',
                      errorText: state.passwordError ? 'Invalid password' : null,
                      suffixIcon: IconButton(
                        icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                      ),
                    ),
                    obscureText: !_passwordVisible,
                    onChanged: (value) => _loginCubit.passwordChanged(value),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        LoginButton(onPressed: isLoginButtonEnabled(state) ? _onFormSubmitted : () => print('Login button failed')),
                        const GoogleLoginButton(),
                        const AppleLoginButton(),
                        const AnonLoginButton(),
                        const PhoneLoginButton(),
                        const CreateAccountButton(),
                        const MicrosoftLoginButton(),
                      ],
                    ),
                  ),
                  ForgotPasswordButton(onPressed: _emailController.text.isNotEmpty ? () => _onResetSubmitted() : () => print('ForgotPasswordButton executed null function')),
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onFormSubmitted() {
    _loginCubit.loginWithEmailPasswordPressed(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  void _onResetSubmitted() {
    _loginCubit.sendPasswordResetEmail(_emailController.text);
  }
}
