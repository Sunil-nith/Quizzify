import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiz_app/api_service/quiz_api.dart';
import 'package:quiz_app/screens/loading.dart';
import 'package:quiz_app/screens/result_details.dart';

class QuizResultScreen extends StatefulWidget {
  final String quizId;

  const QuizResultScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  late Future<List<Map<String, dynamic>>> _quizResults;

  @override
  void initState() {
    super.initState();
    _quizResults = QuizService().getQuizResult(widget.quizId);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz Results',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _quizResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingScreen());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final quizResults = snapshot.data!;
            if (quizResults.isEmpty) {
              return const Center(
                child: Text(
                  'No one has taken this test.',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              );
            }
           
            return ListView.builder(
              itemCount: quizResults.length,
              itemBuilder: (context, index) {
                final result = quizResults.reversed.toList()[index];
                 return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultDetailScreen(
                          quizResult: result,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        '${result['userEmail']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Quiz Taken On: ${DateFormat.yMMMd().add_jms().format(DateTime.parse(result['createdAt']).add(const Duration(hours: 5, minutes: 30)))}', // Converted to IST and added time format
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
