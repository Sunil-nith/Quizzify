import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiz_app/api_service/quiz_api.dart';
import 'package:quiz_app/screens/loading.dart';
import 'package:quiz_app/screens/quiz_details.dart';

class ViewQuizScreen extends StatefulWidget {
  const ViewQuizScreen({Key? key}) : super(key: key);

  @override
  State<ViewQuizScreen> createState() => _ViewQuizScreenState();
}

class _ViewQuizScreenState extends State<ViewQuizScreen> {
  late List<Map<String, dynamic>> quizData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await QuizService().getQuiz();
      data.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
      setState(() {
        quizData = data;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching quiz data: $error');
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _navigateToQuizDetails(Map<String, dynamic> quizData) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizDetailScreen(quizData: quizData),
      ),
    );
    await fetchData();
  }

  Widget _buildQuizListItem(BuildContext context, int index) {
  final item = quizData[index];
  final createdAtIST = DateTime.parse(item['createdAt']).add(const Duration(hours: 5, minutes: 30));
  final updatedAtIST = DateTime.parse(item['updatedAt']).add(const Duration(hours: 5, minutes: 30));

  return GestureDetector(
    onTap: () => _navigateToQuizDetails(item),
    child: Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quiz Name: ${item['name']}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Quiz ID: ${item['_id']}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Created At: ${DateFormat.yMMMd().add_jms().format(createdAtIST)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Updated At: ${DateFormat.yMMMd().add_jms().format(updatedAtIST)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Your Quizzes', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(
              child: LoadingScreen(),
            )
          : quizData.isNotEmpty
              ? ListView.builder(
                  itemCount: quizData.length,
                  itemBuilder: _buildQuizListItem,
                )
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'You have not created any quizzes yet.',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchData,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
