import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz_model.dart';

class QuizService {
  static const String apiUrl = 'https://api.jsonserve.com/Uw5CrX';

  Future<Quiz> fetchQuiz() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return Quiz.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load quiz: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load quiz: $e');
    }
  }
}
