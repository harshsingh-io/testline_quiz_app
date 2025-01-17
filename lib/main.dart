import 'package:flutter/material.dart';
import 'screens/quiz_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _handleThemeToggle() {
    setState(() {
      if (_themeMode == ThemeMode.system) {
        // If currently using system theme, switch to explicit light/dark based on current brightness
        final brightness = MediaQuery.platformBrightnessOf(context);
        _themeMode =
            brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
      } else if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  IconData _getThemeIcon() {
    if (_themeMode == ThemeMode.system) {
      return Icons.brightness_auto;
    }
    return _themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testline Quiz',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: QuizScreen(
        onThemeToggle: _handleThemeToggle,
        themeMode: _themeMode,
      ),
    );
  }
}
