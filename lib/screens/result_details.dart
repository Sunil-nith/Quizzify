import 'package:flutter/material.dart';
import 'package:quiz_app/api_service/quiz_api.dart';
import 'package:quiz_app/screens/loading.dart';

class ResultDetailScreen extends StatefulWidget {
  final Map<String, dynamic> quizResult;

  const ResultDetailScreen({Key? key, required this.quizResult})
      : super(key: key);

  @override
  State<ResultDetailScreen> createState() => _ResultDetailScreenState();
}

class _ResultDetailScreenState extends State<ResultDetailScreen> {
  late Map<String, dynamic> quizData;
  bool _isQuizLoaded = false;
  int score = 0;
  int totalQuestions = 0;
  int attemptedQuestions = 0;

  @override
  void initState() {
    super.initState();
    if (!widget.quizResult.containsKey('answers')) {
      widget.quizResult['answers'] = {};
    }
    _fetchQuizData();
  }

  Future<void> _fetchQuizData() async {
    try {
      final data = await QuizService().startExam(widget.quizResult['quizId']);
      setState(() {
        quizData = data;
        _isQuizLoaded = true;
        calculateScore();
        calculateAttemptedQuestions();
      });
    } catch (error) {
      print('Error fetching quiz data: $error');
      throw error;
    }
  }

  void calculateScore() {
    score = 0;
    for (final question in quizData['questions_list']) {
      final questionId = question['_id'];
      final selectedAnswer =
          widget.quizResult['answers'][questionId].toString();
      final correctOption = question['correctOption'].toString();
      if (selectedAnswer == correctOption) {
        score++;
      }
    }
  }

  void calculateAttemptedQuestions() {
    attemptedQuestions = 0;
    for (final questionId in widget.quizResult['answers'].keys) {
      if (widget.quizResult['answers'][questionId] != null) {
        attemptedQuestions++;
      }
    }
    totalQuestions = quizData['questions_list'].length;
  }

  Widget _buildQuizDetail() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: quizData['questions_list'].length,
      itemBuilder: (context, index) {
        final question = quizData['questions_list'][index];
        final questionId = question['_id'];
        var selectedAnswer =
            widget.quizResult['answers'][questionId]?.toString();
        final correctOption = question['correctOption'];
        final options = question['options'];
        final isCorrect = selectedAnswer == correctOption;
        selectedAnswer ??= 'Not Answered';
        final cardColor = selectedAnswer == 'Not Answered'
            ? Colors.white
            : isCorrect
                ? Colors.green
                : Colors.red;

        return Card(
          margin: const EdgeInsets.all(16.0),
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question ${index + 1}: ${question['question']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 8.0),
                const Text('Options:', style: TextStyle(color: Colors.black)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      (options as Map<String, dynamic>).entries.map((entry) {
                    final optionNumber = entry.key;
                    final optionText = entry.value;
                    return ListTile(
                      title: Text('$optionNumber. $optionText',
                          style: const TextStyle(color: Colors.black)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8.0),
                Text('Correct Option: $correctOption',
                    style: const TextStyle(color: Colors.black)),
                const SizedBox(height: 8.0),
                Text('Selected Option: $selectedAnswer',
                    style: const TextStyle(color: Colors.black)),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String quizId = widget.quizResult['quizId'];
    String quizName = widget.quizResult['quizName'];
    String quizCreatedBy = widget.quizResult['quizCreatedBy'];
    String quizTakenBy = widget.quizResult['userEmail'];
    int timeTaken = widget.quizResult['timeTaken'];
    String formattedTime =
        '${(timeTaken / 60).floor()} minutes ${(timeTaken % 60)} seconds';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Result Detail',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: _isQuizLoaded
          ? ListView(
              children: [
                Card(
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quiz ID: $quizId',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Quiz Name: $quizName',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Quiz Created By: $quizCreatedBy',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Quiz Taken By: $quizTakenBy',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Time Taken: $formattedTime',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Total Questions: $totalQuestions',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Attempted Questions: $attemptedQuestions',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color:Colors.orange
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Corrected Answers: $score',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildQuizDetail(),
              ],
            )
          : const Center(
              child: LoadingScreen(),
            ),
    );
  }
}
