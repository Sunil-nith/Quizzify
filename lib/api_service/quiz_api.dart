import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz_app/api_service/auth_service.dart';
import 'package:quiz_app/config/constants.dart';

class QuizService {
  final baseUrl = Constants.baseUrl;
  Future<bool> createQuiz(Map<String, dynamic> quizData) async {
    final token = await AuthenticationHelper().getIdToken();
    final apiUrl = '$baseUrl/quiz';
    var url = Uri.parse(apiUrl);
    var jsonString = jsonEncode(quizData);
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonString,
      );

      if (response.statusCode == 201) {
        print('Data sent successfully');
        return true;
      } else {
        print('Failed to send data. Error: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error sending data: $error');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getQuiz() async {
    final token = await AuthenticationHelper().getIdToken();
    final apiUrl = '$baseUrl/quiz';
    var url = Uri.parse(apiUrl);

    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print('Quiz data received successfully');
        return responseData.cast<Map<String, dynamic>>();
      } else {
        print('Failed to get quiz data. Error: ${response.statusCode}');
        throw Exception('Failed to get quiz data');
      }
    } catch (error) {
      print('Error getting quiz data: $error');
      throw Exception('Error getting quiz data');
    }
  }

  Future<bool> deleteQuiz(String quizId) async {
    final token = await AuthenticationHelper().getIdToken();
    final apiUrl = '$baseUrl/quiz/$quizId';
    var url = Uri.parse(apiUrl);
    try {
      var response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        print('Quiz not found'); // Log error message
        return false;
      } else if (response.statusCode == 403) {
        print(
            'You are not authorized to delete this Quiz'); // Log error message
        return false;
      } else {
        print(
            'Failed to delete quiz: ${response.statusCode}'); // Log generic error message
        return false;
      }
    } catch (error) {
      print(
          'An error occurred while deleting the Quiz: $error'); // Log error message
      return false;
    }
  }

  Future<bool> updateQuiz(String quizId, Map<String, dynamic> quizData) async {
    final token = await AuthenticationHelper().getIdToken();
    var apiUrl = '$baseUrl/quiz/$quizId';
    var url = Uri.parse(apiUrl);
    var jsonString = jsonEncode(quizData);
    try {
      var response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonString,
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        print('Quiz not found');
        return false;
      } else if (response.statusCode == 403) {
        print(
            'You are not authorized to update this Quiz'); // Log error message
        return false;
      } else {
        print(
            'Failed to update quiz: ${response.statusCode}'); // Log generic error message
        return false;
      }
    } catch (error) {
      print(
          'An error occurred while updating the Quiz: $error'); // Log error message
      return false;
    }
  }

  Future<Map<String, dynamic>> startExam(String quizId) async {
    final token = await AuthenticationHelper().getIdToken();
    final apiUrl = '$baseUrl/exam/$quizId';
    var url = Uri.parse(apiUrl);
    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to start exam. Error: ${response.statusCode}');
        throw Exception('Failed to start exam');
      }
    } catch (error) {
      print('Error starting exam: $error');
      throw Exception('Error starting exam');
    }
  }

  Future<bool> submitExam(String quizId, int attemptedQuestions,
      int correctAnswers, int totalQuestions, int elapsedTime, answers) async {
    final token = await AuthenticationHelper().getIdToken();
    var apiUrl = '$baseUrl/exam/$quizId';
    var url = Uri.parse(apiUrl);
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'correctAnswers': correctAnswers,
          'totalQuestions': totalQuestions,
          'attemptedQuestions': attemptedQuestions,
          'timeTaken': elapsedTime,
          'answers': answers
        }),
      );

      if (response.statusCode == 200) {
        return true; // Submission successful
      } else {
        print('Failed to submit exam: ${response.statusCode}');
        return false; // Submission failed
      }
    } catch (error) {
      print('Error submitting exam: $error');
      return false; // Submission failed due to error
    }
  }

  Future<List<Map<String, dynamic>>> getYourResult() async {
    final token = await AuthenticationHelper().getIdToken();
    final apiUrl = '$baseUrl/result';
    var url = Uri.parse(apiUrl);

    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return responseData.cast<Map<String, dynamic>>();
      } else if (response.statusCode == 404) {
        print("You haven't taken any exams");
        return []; // Return an empty list if no exams are taken
      } else {
        print('Failed to get quiz results. Error: ${response.statusCode}');
        throw Exception('Failed to get quiz results');
      }
    } catch (error) {
      print('Error getting quiz results: $error');
      throw Exception('Error getting quiz results');
    }
  }

  Future<List<Map<String, dynamic>>> getQuizResult(String quizId) async {
    final token = await AuthenticationHelper().getIdToken();
    final apiUrl = '$baseUrl/result/$quizId';
    var url = Uri.parse(apiUrl);

    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return responseData.cast<Map<String, dynamic>>();
      } else if (response.statusCode == 404) {
        print("No quiz results found for the given quizId");
        return []; // Return an empty list if no exams are taken
      } else {
        print('Failed to get quiz results. Error: ${response.statusCode}');
        throw Exception('Failed to get quiz results');
      }
    } catch (error) {
      print('Error getting quiz results: $error');
      throw Exception('Error getting quiz results');
    }
  }
}
