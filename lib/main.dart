import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _handleThemeToggle() {
    setState(() {
      if (_themeMode == ThemeMode.system) {
        final brightness = MediaQuery.platformBrightnessOf(context);
        _themeMode =
            brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
      } else if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.system;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: SplashScreen(
        onThemeToggle: _handleThemeToggle,
        themeMode: _themeMode,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
