import 'package:frameapp/core/navigation.dart';
import 'package:frameapp/ui/screens/home_screen.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:flutter/material.dart';

class FrameApp extends StatelessWidget {
  const FrameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!FocusScope.of(context).hasPrimaryFocus) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: MaterialApp(
        onGenerateRoute: Navigation.generateRoute,
        debugShowCheckedModeBanner: false,
        themeMode: kDefaultThemeMode,
        theme: FrameTheme.lightTheme(true),
        darkTheme: FrameTheme.darkTheme(true),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
        home: HomeScreen(),
      ),
    );
  }
}
