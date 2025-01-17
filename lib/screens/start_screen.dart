import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'quiz_screen.dart';

class StartScreen extends StatelessWidget {
  final VoidCallback onThemeToggle;
  final ThemeMode themeMode;

  const StartScreen({
    super.key,
    required this.onThemeToggle,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.system
                  ? Icons.brightness_auto
                  : themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: onThemeToggle,
            tooltip: themeMode == ThemeMode.system
                ? 'Auto theme'
                : themeMode == ThemeMode.dark
                    ? 'Switch to light theme'
                    : 'Switch to dark theme',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/app_logo.webp',
                    width: 180,
                    height: 180,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Welcome to TestLine Quiz!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Test your knowledge with our exciting quiz questions',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => QuizScreen(
                          onThemeToggle: onThemeToggle,
                          themeMode: themeMode,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Start Quiz',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
