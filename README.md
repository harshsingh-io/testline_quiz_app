# Testline Quiz App

<p align="center">
  <img src="assets/AppLogo.png" alt="Testline Quiz Logo" width="200"/>
</p>

A modern, feature-rich quiz application built with Flutter that offers an engaging and interactive quiz-taking experience with gamification elements.

## Download

Get the latest version of Testline Quiz:

<p align="center">
  <a href="https://github.com/harshsingh-io/testline_quiz_app/raw/main/app-debug.apk">
    <img src="https://img.shields.io/badge/Download-APK-blue?style=for-the-badge&logo=android" alt="Download APK"/>
  </a>
</p>

## Demo

Check out the app in action:

https://github.com/harshsingh-io/testline_quiz_app/raw/main/assets/demo_video.mp4

Or watch on YouTube:

[![Testline Quiz Demo](https://img.youtube.com/vi/YhAgioI4fI8/0.jpg)](https://youtube.com/shorts/YhAgioI4fI8?feature=share)

<p align="center">
  <a href="https://youtube.com/shorts/YhAgioI4fI8?feature=share">
    <img src="https://img.shields.io/badge/Watch-Demo_on_YouTube-red?style=for-the-badge&logo=youtube" alt="Watch Demo on YouTube"/>
  </a>
</p>

## Features

### Core Functionality
- Dynamic quiz loading from API
- Multiple-choice questions with detailed explanations
- Positive and negative marking system
- 60-second timer per question with auto-skip
- Question skipping with confirmation
- Comprehensive result review
- Markdown support for explanations

### User Interface
- Clean and intuitive Material Design
- Interactive question navigation
- Animated progress tracking
- Visual feedback for answers
- Countdown timer with warning states
- Skip and Submit buttons for each question

### Gamification Elements
- Points system (+4 for correct, -1 for incorrect)
- Achievement badges:
  - Perfect Score: All questions correct
  - Speed Runner: No questions skipped
  - Sharpshooter: Accuracy above 80%
- Animated score updates
- Confetti celebration on completion
- Performance statistics

### Theme Support
- Light and dark theme support
- System theme detection
- Theme toggle functionality
- Consistent styling across themes
- Adaptive color schemes

### Result Analysis
- Overall score with circular progress
- Correct/incorrect answer statistics
- Accuracy percentage
- Skipped questions tracking
- Detailed question-by-question review
- Animated result cards
- Solution explanations in markdown

## Screenshots

### Dark Theme
| ![Dark Theme 1](assets/screenshots/dark_theme/1.jpg) | ![Dark Theme 2](assets/screenshots/dark_theme/2.jpg) | ![Dark Theme 3](assets/screenshots/dark_theme/3.jpg) |
|:---:|:---:|:---:|
| ![Dark Theme 4](assets/screenshots/dark_theme/4.jpg) | ![Dark Theme 5](assets/screenshots/dark_theme/5.jpg) |  |

### Light Theme
| ![Light Theme 1](assets/screenshots/light_theme/1.jpg) | ![Light Theme 2](assets/screenshots/light_theme/2.jpg) | ![Light Theme 3](assets/screenshots/light_theme/3.jpg) |
|:---:|:---:|:---:|
| ![Light Theme 4](assets/screenshots/light_theme/4.jpg) | ![Light Theme 5](assets/screenshots/light_theme/5.jpg) | ![Light Theme 6](assets/screenshots/light_theme/6.jpg) |

### General Screenshots
| ![Screenshot 1](assets/screenshots/1.jpg) | ![Screenshot 2](assets/screenshots/2.jpg) |
|:---:|:---:|

## Technical Details

### Prerequisites
- Flutter SDK (2.0 or higher)
- Dart SDK (2.12 or higher)
- An IDE (VS Code, Android Studio, etc.)

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  flutter_markdown: ^0.6.18
  confetti: ^0.8.0
```

### Project Structure
```
lib/
├── main.dart
├── models/
│   └── quiz_model.dart
├── screens/
│   └── quiz_screen.dart
├── services/
│   └── quiz_service.dart
├── theme/
│   └── app_theme.dart
└── widgets/
    ├── animated_progress_bar.dart
    ├── animated_result_card.dart
    ├── circular_score.dart
    ├── confetti_overlay.dart
    ├── countdown_timer.dart
    ├── performance_badge.dart
    └── score_animation.dart
```

## Features in Detail

### Quiz Flow
1. Questions are fetched from the API
2. Each question has a 60-second timer
3. Users can:
   - Select an answer
   - Skip questions (with confirmation)
   - See immediate feedback
4. Timer auto-skips if no answer is selected
5. Score calculation:
   - Correct answers: +4 points
   - Incorrect answers: -1 point (minimum score: 0)
   - Skipped questions: No points deducted

### Timer Functionality
- 60-second countdown per question
- Visual progress indicator
- Color changes for last 15 seconds
- Auto-skip on timeout
- Pauses during transitions

### Theme Management
- Automatic system theme detection
- Manual theme toggle
- Theme-specific colors
- Consistent styling
- Adaptive components

### Result Review
- Comprehensive performance summary
- Achievement badges
- Statistical breakdown
- Question-by-question review with:
  - Original question
  - User's answer
  - Correct answer (if wrong)
  - Detailed explanation
  - Special indication for skipped questions

## API Integration

The app fetches quiz data from:
```
https://api.jsonserve.com/Uw5CrX
```

Response includes:
- Quiz metadata
- Questions and options
- Correct answers
- Detailed explanations
- Marking scheme

## Installation

1. Clone the repository:
```bash
git clone https://github.com/harshsingh-io/testline_quiz_app.git
```

2. Navigate to project directory:
```bash
cd testline_quiz_app
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Repository

You can find the source code at [github.com/harshsingh-io/testline_quiz_app](https://github.com/harshsingh-io/testline_quiz_app)
