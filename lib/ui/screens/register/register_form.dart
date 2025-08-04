import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/ui/screens/register/register_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_user_repository/sp_user_repository.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final RegisterCubit _registerCubit = sl<RegisterCubit>();
  final AuthenticationCubit _authenticationCubit = sl<AuthenticationCubit>();

  bool _passwordVisible = false;

  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty && _confirmPasswordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return isPopulated && !state.isInProgress;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      bloc: _registerCubit,
      listener: (context, state) {
        if (state.isInProgress) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Registering...', style: TextStyle(color: Colors.white)), CircularProgressIndicator(color: Colors.white)])));
        }

        if (state.isSuccess) {
          _authenticationCubit.sendVerificationEmail();
          Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
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
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.email),
                      labelText: 'Email',
                      errorText: state.emailError ? 'Invalid email' : null,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    keyboardAppearance: Brightness.dark,
                    autocorrect: false,
                    onChanged: (value) => _registerCubit.emailChanged(value),
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
                    autocorrect: false,
                    onChanged: (value) => _registerCubit.passwordChanged(value),
                  ),
                  TextFormField(
                    keyboardAppearance: Brightness.dark,
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock),
                      labelText: 'Confirm Password',
                      errorText: state.confirmPasswordError ? 'Invalid password / Passwords doesnt match' : null,
                      suffixIcon: IconButton(
                        icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                      ),
                    ),
                    obscureText: !_passwordVisible,
                    autocorrect: false,
                    onChanged: (value) => _registerCubit.confirmPasswordChanged(value),
                  ),
                  RegisterButton(onPressed: isRegisterButtonEnabled(state) ? _onFormSubmitted : () {}),
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
    _registerCubit.registerSubmitted(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }
}
