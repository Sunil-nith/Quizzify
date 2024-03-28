import 'package:flutter/material.dart';
import 'package:quiz_app/api_service/auth_service.dart';
import 'package:quiz_app/screens/start_exam.dart';
import 'package:quiz_app/screens/your_result.dart';
import 'package:quiz_app/screens/create_quiz.dart';
import 'package:quiz_app/screens/start_page.dart';
import 'package:quiz_app/screens/view_quiz.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _signOut(BuildContext context) {
    AuthenticationHelper().signOut().then(
          (_) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Wrapper(),
            ),
          ),
        );
  }

  void _navigateToViewQuizScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ViewQuizScreen(),
      ),
    );
  }

  void _navigateToStartExamScreen(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String quizId = '';
        return AlertDialog(
          title: const Text('Enter Quiz ID'),
          content: TextField(
            onChanged: (value) {
              quizId = value;
            },
            decoration: const InputDecoration(hintText: 'Quiz ID'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>StartExamScreen(quizId: quizId),
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToResultScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ResultScreen(),
      ),
    );
  }

  void _navigateToCreateQuizScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateQuiz(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Quizzify',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.blue, // Adjust the color to your preference
            ),
          ),
          const Text(
            "Let's create, share, and participate",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey, // Adjust the color to your preference
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 200,
            child: Column(children: [
              ElevatedButton(
                onPressed: () => _navigateToViewQuizScreen(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue, // Adjust the color to your preference
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  textStyle: const TextStyle(fontSize: 18),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Your Quizzes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _navigateToCreateQuizScreen(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green, // Adjust the color to your preference
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  textStyle: const TextStyle(fontSize: 18),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Create a Quiz',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _navigateToStartExamScreen(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.orange, // Adjust the color to your preference
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  textStyle: const TextStyle(fontSize: 18),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Take a Quiz',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _navigateToResultScreen(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.purple, // Adjust the color to your preference
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  textStyle: const TextStyle(fontSize: 18),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Your Results',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _signOut(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red, // Adjust the color to your preference
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  textStyle: const TextStyle(fontSize: 18),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ]),
          )
        ],
      )),
    );
  }
}
