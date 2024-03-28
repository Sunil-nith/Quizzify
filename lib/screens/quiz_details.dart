import 'package:flutter/material.dart';
import 'package:quiz_app/api_service/quiz_api.dart';
import 'package:quiz_app/screens/create_quiz.dart';
import 'package:quiz_app/screens/home_page.dart';
import 'package:quiz_app/screens/loading.dart';
import 'package:quiz_app/screens/quiz_result.dart';
import 'package:share_plus/share_plus.dart';

class QuizDetailScreen extends StatefulWidget {
  final Map<String, dynamic> quizData;

  const QuizDetailScreen({Key? key, required this.quizData}) : super(key: key);

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  bool _isDeleting = false;

  Future<void> _deleteQuiz() async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to delete this quiz?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); 
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); 
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
    if (confirmDelete == true) {
      setState(() {
        _isDeleting = true;
      });

      try {
        final bool success =
            await QuizService().deleteQuiz(widget.quizData['_id']);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Quiz deleted successfully!'),
            duration: Duration(seconds: 3),
          ),
        );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Failed to delete quiz'),
              content: const Text('An error occurred while deleting the quiz.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } catch (error) {
        print('Error deleting quiz: $error');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Failed to delete quiz'),
            content: Text('An error occurred while deleting the quiz: $error'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Details',
            style:
                TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quiz ID: ${widget.quizData['_id']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'Quiz Name:  ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.quizData['name'],
                        style: const TextStyle(fontSize: 16),
                        
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final quizId = widget.quizData['_id'];
                    Share.share(quizId);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue, 
                    elevation: 3,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12), 
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.share), 
                      SizedBox(width: 8), 
                      Text(
                        'Share Quiz ID',
                        style: TextStyle(fontSize: 14), 
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                for (int i = 0;
                    i < widget.quizData['questions_list'].length;
                    i++)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${i + 1}: ${widget.quizData['questions_list'][i]['question']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Options:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 16),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var option in widget
                              .quizData['questions_list'][i]['options'].entries)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                              child: Text('${option.key}: ${option.value}',
                                  style: const TextStyle(fontSize: 16)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Correct Option: ${widget.quizData['questions_list'][i]['correctOption']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
              ],
            ),
          ),
          if (_isDeleting)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: LoadingScreen(),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        QuizResultScreen(quizId: widget.quizData['_id']),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12), 
                textStyle: const TextStyle(fontSize: 16), 
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),
              child: const Text('Quiz Results'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateQuiz(quizData: widget.quizData),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green, 
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), 
                ),
              ),
              child: const Text('Edit Quiz'),
            ),
            ElevatedButton(
              onPressed: _isDeleting ? null : () => _deleteQuiz(),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Delete Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
