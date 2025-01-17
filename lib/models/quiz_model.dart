class Quiz {
  final int id;
  final String title;
  final String description;
  final String topic;
  final DateTime time;
  final bool isPublished;
  final int duration;
  final DateTime endTime;
  final double negativeMarks;
  final double correctAnswerMarks;
  final bool shuffle;
  final bool showAnswers;
  final bool lockSolutions;
  final int questionsCount;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.topic,
    required this.time,
    required this.isPublished,
    required this.duration,
    required this.endTime,
    required this.negativeMarks,
    required this.correctAnswerMarks,
    required this.shuffle,
    required this.showAnswers,
    required this.lockSolutions,
    required this.questionsCount,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      topic: json['topic'] ?? '',
      time: DateTime.parse(json['time'] ?? DateTime.now().toIso8601String()),
      isPublished: json['is_published'] ?? false,
      duration: json['duration'] ?? 0,
      endTime:
          DateTime.parse(json['end_time'] ?? DateTime.now().toIso8601String()),
      negativeMarks: double.parse(json['negative_marks'] ?? '0'),
      correctAnswerMarks: double.parse(json['correct_answer_marks'] ?? '0'),
      shuffle: json['shuffle'] ?? false,
      showAnswers: json['show_answers'] ?? false,
      lockSolutions: json['lock_solutions'] ?? false,
      questionsCount: json['questions_count'] ?? 0,
      questions: (json['questions'] as List? ?? [])
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }
}

class Question {
  final int id;
  final String description;
  final String topic;
  final bool isPublished;
  final String detailedSolution;
  final List<Option> options;

  Question({
    required this.id,
    required this.description,
    required this.topic,
    required this.isPublished,
    required this.detailedSolution,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      description: json['description'] ?? '',
      topic: json['topic'] ?? '',
      isPublished: json['is_published'] ?? false,
      detailedSolution: json['detailed_solution'] ?? '',
      options: (json['options'] as List? ?? [])
          .map((o) => Option.fromJson(o))
          .toList(),
    );
  }
}

class Option {
  final int id;
  final String description;
  final bool isCorrect;

  Option({
    required this.id,
    required this.description,
    required this.isCorrect,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'] ?? 0,
      description: json['description'] ?? '',
      isCorrect: json['is_correct'] ?? false,
    );
  }
}
