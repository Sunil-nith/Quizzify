import 'package:flutter/material.dart';
import 'package:quiz_app/api_service/quiz_api.dart';
import 'package:intl/intl.dart';
import 'package:quiz_app/screens/loading.dart';
import 'package:quiz_app/screens/result_details.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<Map<String, dynamic>> quizResults = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuizResults();
  }

  Future<void> _fetchQuizResults() async {
    try {
      List<Map<String, dynamic>> results = await QuizService().getYourResult();
      results.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
      setState(() {
        quizResults = results;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching quiz results: $error');
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Results',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: LoadingScreen())
          : quizResults.isEmpty
              ? const Center(
                  child: Text(
                    'You have not taken any exams.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: quizResults.length,
                  itemBuilder: (context, index) {
                    final result = quizResults[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ResultDetailScreen(quizResult: result),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quiz Name: ${result['quizName']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text('Quiz ID: ${result['quizId']}'),
                              const SizedBox(height: 1),
                              Text(
                                'Created By: ${result['quizCreatedBy']}',
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Quiz Taken On: ${DateFormat.yMMMd().add_jms().format(DateTime.parse(result['createdAt']).add(const Duration(hours: 5, minutes: 30)))}', // Converted to IST and added time format
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
