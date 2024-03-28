import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/api_service/quiz_api.dart';
import 'package:quiz_app/screens/home_page.dart';
import 'package:quiz_app/screens/loading.dart';

class ExamDetailScreen extends StatefulWidget {
  final Map<String, dynamic> quizData;
  const ExamDetailScreen({Key? key, required this.quizData}) : super(key: key);

  @override
  State<ExamDetailScreen> createState() => _ExamDetailScreenState();
}

class _ExamDetailScreenState extends State<ExamDetailScreen> {
  Map<String, int?> selectedAnswers = {};
  late Timer _timer;
  int _elapsedSeconds = 0;
  bool _isQuizSubmitted = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _submitQuizConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Submission'),
          content: const Text('Are you sure you want to submit the quiz?'),
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
                _submitQuiz();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizData = widget.quizData;
    return WillPopScope(
      onWillPop: () async {
        if (_isQuizSubmitted) {
          return true;
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Quiz Submission Required'),
              content: const Text('Please submit the quiz before leaving.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Time Elapsed: ${_formatTime(_elapsedSeconds)}'),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quiz Name: ${quizData['name']}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Quiz ID: ${quizData['_id']}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Created By: ${quizData['userEmail']}',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      'Questions:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    for (var i = 0;
                        i < (quizData['questions_list'] ?? []).length;
                        i++) ...[
                      Text(
                        'Question ${i + 1}: ${quizData['questions_list'][i]['question']}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var option in (quizData['questions_list'][i]
                                      ['options'] ??
                                  {})
                              .entries)
                            RadioListTile<int>(
                              title: Text('${option.key}: ${option.value}'),
                              value: int.parse(option.key),
                              groupValue: selectedAnswers[
                                  '${quizData['questions_list'][i]['_id']}'], // Use question ID as key
                              onChanged: (value) {
                                setState(() {
                                  selectedAnswers[
                                          '${quizData['questions_list'][i]['_id']}'] =
                                      value;
                                });
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitQuizConfirmation,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: const RoundedRectangleBorder()),
                child: const Text(
                  'Submit Quiz',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _submitQuiz() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: LoadingScreen(),
      ),
    );
    int correctAnswers = 0;
    int attemptedQuestions = 0;
    final quizData = widget.quizData;
    for (var i = 0; i < (quizData['questions_list'] ?? []).length; i++) {
      if (selectedAnswers
          .containsKey('${quizData['questions_list'][i]['_id']}')) {
        attemptedQuestions++;
        if (selectedAnswers['${quizData['questions_list'][i]['_id']}']
                .toString() ==
            quizData['questions_list'][i]['correctOption']) {
          correctAnswers++;
        }
      }
    }
    final totalQuestions = (quizData['questions_list'] ?? []).length;
    try {
      bool submissionSuccess = await QuizService().submitExam(
          quizData['_id'],
          attemptedQuestions,
          correctAnswers,
          totalQuestions,
          _elapsedSeconds,
          selectedAnswers);
      if (submissionSuccess) {
        setState(() {
          _isQuizSubmitted = true;
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
        double score =
            totalQuestions == 0 ? 0 : (correctAnswers / totalQuestions) * 100;

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Quiz Results'),
            content: Text(
                'You scored $correctAnswers out of $totalQuestions (${score.toStringAsFixed(2)} %)'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      } else {
        Navigator.of(context).pop();

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Submission Failed'),
            content: const Text(
                'Failed to submit the quiz. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred: $error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }
}
