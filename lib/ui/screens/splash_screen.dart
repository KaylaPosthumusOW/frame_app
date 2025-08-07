import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/pngs/splash_image.png', width: 200, height: 200),
            SizedBox(height: 20),
            Text(
              'Welcome to Our App',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              'Loading...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
