import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/quiz_model.dart';
import '../services/quiz_service.dart';
import '../widgets/animated_progress_bar.dart';
import '../widgets/score_animation.dart';
import '../widgets/confetti_overlay.dart';
import '../widgets/performance_badge.dart';
import '../widgets/circular_score.dart';
import '../widgets/animated_result_card.dart';
import '../widgets/countdown_timer.dart';

class QuizScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final ThemeMode themeMode;

  const QuizScreen({
    Key? key,
    required this.onThemeToggle,
    required this.themeMode,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<Quiz> _quizFuture;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;
  Map<int, int> _userAnswers = {};
  int? _selectedOptionId;
  Set<int> _skippedQuestions = {};
  bool _showScoreAnimation = false;
  bool _lastAnswerCorrect = false;
  bool _showConfetti = false;
  bool _isTimerPaused = false;

  @override
  void initState() {
    super.initState();
    _quizFuture = QuizService().fetchQuiz();
  }

  void _selectOption(int optionId) {
    setState(() {
      _selectedOptionId = optionId;
    });
  }

  void _submitAnswer(Quiz quiz) {
    if (_selectedOptionId != null) {
      setState(() => _isTimerPaused = true);
      final selectedOption = quiz.questions[_currentQuestionIndex].options
          .firstWhere((o) => o.id == _selectedOptionId);

      setState(() {
        _userAnswers[_currentQuestionIndex] = _selectedOptionId!;
        _showScoreAnimation = true;
        _lastAnswerCorrect = selectedOption.isCorrect;

        if (selectedOption.isCorrect) {
          _score += quiz.correctAnswerMarks.toInt();
        } else {
          _score = (_score - quiz.negativeMarks.toInt())
              .clamp(0, double.infinity)
              .toInt();
        }

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _showScoreAnimation = false;
            });
          }
        });

        if (_currentQuestionIndex < quiz.questions.length - 1) {
          _currentQuestionIndex++;
          _selectedOptionId = null;
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              setState(() => _isTimerPaused = false);
            }
          });
        } else {
          _quizCompleted = true;
          setState(() {
            _showConfetti = true;
          });
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                _showConfetti = false;
              });
            }
          });
        }
      });
    }
  }

  Future<bool> _showSkipConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Skip Question'),
              content:
                  const Text('Are you sure you want to skip this question?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false; // Default to false if dialog is dismissed
  }

  void _skipQuestion(Quiz quiz, {bool autoSkip = false}) async {
    final shouldSkip = autoSkip ? true : await _showSkipConfirmationDialog();
    if (shouldSkip) {
      setState(() => _isTimerPaused = true);
      setState(() {
        _skippedQuestions.add(_currentQuestionIndex);
        if (_currentQuestionIndex < quiz.questions.length - 1) {
          _currentQuestionIndex++;
          _selectedOptionId = null;
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              setState(() => _isTimerPaused = false);
            }
          });
        } else {
          _quizCompleted = true;
        }
      });
    }
  }

  void _handleTimeUp(Quiz quiz) {
    if (!_quizCompleted && !_isTimerPaused) {
      _skipQuestion(quiz, autoSkip: true);
    }
  }

  Widget _buildQuestionCard(Question question, Quiz quiz) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedProgressBar(
                  flex: 4,
                  currentQuestion: _currentQuestionIndex + 1,
                  totalQuestions: quiz.questions.length,
                ),
                const SizedBox(width: 32),
                Flexible(
                  flex: 1,
                  child: CountdownTimer(
                    seconds: 60,
                    onTimerComplete: () => _handleTimeUp(quiz),
                    isPaused: _isTimerPaused,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Question ${_currentQuestionIndex + 1}/${quiz.questions.length}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              question.description,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ...question.options.map((option) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    onPressed: () => _selectOption(option.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedOptionId == option.id
                          ? Theme.of(context).brightness == Brightness.dark
                              ? Colors.blue[700]
                              : Colors.blue[100]
                          : Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.grey[100],
                      foregroundColor: _selectedOptionId == option.id
                          ? Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black
                          : Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      option.description,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: _selectedOptionId == option.id
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _skipQuestion(quiz),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.red[700]
                              : Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Skip Question',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedOptionId == null
                        ? null
                        : () => _submitAnswer(quiz),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Submit Answer',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            if (_showScoreAnimation)
              Align(
                alignment: Alignment.center,
                child: ScoreAnimation(
                  score: _lastAnswerCorrect
                      ? quiz.correctAnswerMarks.toInt()
                      : quiz.negativeMarks.toInt(),
                  isCorrect: _lastAnswerCorrect,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultScreen(Quiz quiz) {
    final totalQuestions = quiz.questions.length;
    final correctAnswers = _userAnswers.entries.where((entry) {
      final question = quiz.questions[entry.key];
      final selectedOption =
          question.options.firstWhere((o) => o.id == entry.value);
      return selectedOption.isCorrect;
    }).length;
    final skippedCount = _skippedQuestions.length;
    final maxPossibleScore = totalQuestions * quiz.correctAnswerMarks.toInt();

    final accuracy = totalQuestions == skippedCount
        ? 0
        : (correctAnswers / (totalQuestions - skippedCount) * 100).round();

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              AnimatedResultCard(
                delay: const Duration(milliseconds: 0),
                child: Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Quiz Completed!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        CircularScore(
                          score: _score,
                          maxScore: maxPossibleScore,
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: [
                            PerformanceBadge(
                              title: 'Perfect Score',
                              description: 'Answered all questions correctly',
                              icon: Icons.star,
                              color: Colors.amber,
                              isAchieved: correctAnswers == totalQuestions,
                            ),
                            PerformanceBadge(
                              title: 'Speed Runner',
                              description: 'No questions skipped',
                              icon: Icons.speed,
                              color: Colors.blue,
                              isAchieved: skippedCount == 0,
                            ),
                            PerformanceBadge(
                              title: 'Sharpshooter',
                              description: 'Accuracy above 80%',
                              icon: Icons.gps_fixed,
                              color: Colors.green,
                              isAchieved: accuracy >= 80,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[900]
                                    : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              _buildStatRow(
                                'Correct Answers',
                                '$correctAnswers/$totalQuestions',
                                Icons.check_circle,
                                Colors.green,
                              ),
                              const SizedBox(height: 8),
                              _buildStatRow(
                                'Accuracy',
                                '$accuracy%',
                                Icons.percent,
                                Colors.blue,
                              ),
                              const SizedBox(height: 8),
                              _buildStatRow(
                                'Skipped',
                                '$skippedCount',
                                Icons.skip_next,
                                Colors.orange,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedResultCard(
                delay: const Duration(milliseconds: 300),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Question Review',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ...quiz.questions.asMap().entries.map(
                (entry) {
                  final index = entry.key;
                  final question = entry.value;
                  final userAnswerId = _userAnswers[index];
                  final userAnswer = userAnswerId != null
                      ? question.options.firstWhere((o) => o.id == userAnswerId)
                      : null;
                  final correctAnswer =
                      question.options.firstWhere((o) => o.isCorrect);

                  return AnimatedResultCard(
                    delay: Duration(milliseconds: 400 + (index * 100)),
                    child: Card(
                      margin: const EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Question ${index + 1}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              question.description,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (_skippedQuestions.contains(index)) ...[
                              const Text(
                                'Question Skipped',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text(
                                    'Correct Answer: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    correctAnswer.description,
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ] else if (userAnswer != null) ...[
                              Row(
                                children: [
                                  const Text(
                                    'Your Answer: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    userAnswer.description,
                                    style: TextStyle(
                                      color: userAnswer.isCorrect
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (!userAnswer.isCorrect) ...[
                                Row(
                                  children: [
                                    const Text(
                                      'Correct Answer: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      correctAnswer.description,
                                      style:
                                          const TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                            if (question.detailedSolution.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              const Text(
                                'Explanation:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey[900]
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: MarkdownBody(
                                  data: question.detailedSolution,
                                  styleSheet: MarkdownStyleSheet(
                                    p: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey[300]
                                          : Colors.grey[900],
                                    ),
                                    strong: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    em: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey[400]
                                          : Colors.grey[700],
                                      fontSize: 16,
                                    ),
                                    blockquote: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    code: TextStyle(
                                      backgroundColor:
                                          Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.grey[800]
                                              : Colors.grey[200],
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey[300]
                                          : Colors.grey[900],
                                      fontSize: 16,
                                    ),
                                    codeblockDecoration: BoxDecoration(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey[800]
                                          : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    listBullet: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey[300]
                                          : Colors.grey[900],
                                    ),
                                  ),
                                  selectable: true,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
              AnimatedResultCard(
                delay: Duration(
                  milliseconds: 400 + (quiz.questions.length * 100) + 100,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentQuestionIndex = 0;
                        _score = 0;
                        _quizCompleted = false;
                        _userAnswers.clear();
                        _selectedOptionId = null;
                        _skippedQuestions.clear();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Restart Quiz',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_showConfetti) const ConfettiOverlay(),
      ],
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _isTimerPaused = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testline Quiz'),
        actions: [
          IconButton(
            icon: Icon(
              widget.themeMode == ThemeMode.system
                  ? Icons.brightness_auto
                  : widget.themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
            ),
            onPressed: widget.onThemeToggle,
            tooltip: widget.themeMode == ThemeMode.system
                ? 'Auto theme'
                : widget.themeMode == ThemeMode.dark
                    ? 'Switch to light theme'
                    : 'Switch to dark theme',
          ),
        ],
      ),
      body: FutureBuilder<Quiz>(
        future: _quizFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No quiz data available'));
          }

          final quiz = snapshot.data!;

          if (_quizCompleted) {
            return _buildResultScreen(quiz);
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    quiz.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildQuestionCard(quiz.questions[_currentQuestionIndex], quiz),
              ],
            ),
          );
        },
      ),
    );
  }
}
