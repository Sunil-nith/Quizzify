import 'package:flutter/material.dart';
import 'package:quiz_app/api_service/quiz_api.dart';
import 'package:quiz_app/screens/exam_details.dart';
import 'package:quiz_app/screens/loading.dart';

class StartExamScreen extends StatefulWidget {
  final String quizId;

  const StartExamScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  State<StartExamScreen> createState() => _StartExamScreenState();
}

class _StartExamScreenState extends State<StartExamScreen> {
  late Map<String, dynamic> quizData;
  bool _isQuizLoaded = false;
  bool _quizNotFound = false;

  @override
  void initState() {
    super.initState();
    _fetchQuizData();
  }

  Future<void> _fetchQuizData() async {
    try {
      final data = await QuizService().startExam(widget.quizId);
      setState(() {
        quizData = data;
        _isQuizLoaded = true;
      });
    } catch (error) {
      print('Error fetching quiz data: $error');
      setState(() {
        _quizNotFound = true;
      });
    }
  }

  void _startExam() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Start Exam Confirmation'),
          content:
              const Text('Once you start the exam, you have to finish it.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToExamDetails();
              },
              child: const Text('Start'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToExamDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExamDetailScreen(quizData: quizData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Start Exam',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: _quizNotFound
          ? const Center(
              child: Text(
                'Quiz not found!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : _isQuizLoaded
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Quiz ID',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                quizData['_id'],
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Quiz Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                quizData['name'],
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Total Questions',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${quizData['questions_list'].length}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Quiz Created By',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                quizData['userEmail'],
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _startExam,
                        child: const Text(
                          'Start Exam',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: LoadingScreen(),
                ),
    );
  }
}
