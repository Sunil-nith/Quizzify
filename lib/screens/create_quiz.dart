import 'package:flutter/material.dart';
import 'package:quiz_app/api_service/quiz_api.dart';
import 'package:quiz_app/screens/home_page.dart';
import 'package:quiz_app/screens/loading.dart';
import 'package:quiz_app/screens/question_form.dart';

class CreateQuiz extends StatefulWidget {
  final Map<String, dynamic>? quizData;
  const CreateQuiz({Key? key, this.quizData}) : super(key: key);

  @override
  State<CreateQuiz> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  late Map<String, dynamic> _quizData;
  final myController = TextEditingController();

  bool _isPosting = false;

  @override
  void initState() {
    super.initState();
    if (widget.quizData != null) {
      myController.text = widget.quizData?['name'];
    }
    _quizData = widget.quizData ?? {"name": '', "questions_list": []};
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  Future<void> _showQuestionDialog(
      {Map<String, dynamic>? question, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionForm(question: question),
      ),
    );
    if (result != null) {
      if (question == null) {
        _addQuestion(result);
      } else {
        _editQuestion(result, index!);
      }
    }
  }

  void _addQuestion(Map<String, dynamic> questionData) {
    _quizData["questions_list"].add({
      "question": questionData["question"],
      "options": {
        "1": questionData["options"]["1"],
        "2": questionData["options"]["2"],
        "3": questionData["options"]["3"],
        "4": questionData["options"]["4"],
      },
      "correctOption": questionData["correctOption"],
    });
    setState(() {});
  }

  void _editQuestion(Map<String, dynamic> questionData, int index) {
    final question = _quizData['questions_list'][index];
    question['question'] = questionData["question"];
    question['options']['1'] = questionData["options"]["1"];
    question['options']['2'] = questionData["options"]["2"];
    question['options']['3'] = questionData["options"]["3"];
    question['options']['4'] = questionData["options"]["4"];
    question['correctOption'] = questionData["correctOption"];

    setState(() {});
  }

  Future<void> _postData() async {
    if (_quizData['name'].isEmpty || _quizData['questions_list'].isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Quiz name and questions are required."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: Text(
              widget.quizData != null && widget.quizData!['_id'] != null
                  ? "Are you sure you want to update this quiz?"
                  : "Are you sure you want to create this quiz?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _performPostData(); // Proceed with posting or updating the quiz
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void _performPostData() async {
    setState(() {
      _isPosting = true;
    });

    bool success = false;

    if (widget.quizData != null && widget.quizData!['_id'] != null) {
      success =
          await QuizService().updateQuiz(widget.quizData!['_id'], _quizData);
    } else {
      success = await QuizService().createQuiz(_quizData);
    }

    setState(() {
      _isPosting = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Quiz ${widget.quizData != null && widget.quizData!['_id'] != null ? 'updated' : 'created'} successfully!'),
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Failed to ${widget.quizData != null && widget.quizData!['_id'] != null ? 'update' : 'create'} quiz!'),
          duration: const Duration(seconds: 3),
        ),
      );
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false, // This will remove all the previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quiz', style: TextStyle(color: Colors.white)), 
        backgroundColor: Colors.blue, 
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 25, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'QUIZ NAME:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20, // Increased font size
                          color: Colors.blue, // Changed color to blue
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 45, // Set the desired height here
                          child: TextField(
                            controller: myController,
                            onChanged: (value) {
                              setState(() {
                                _quizData['name'] = value;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Enter Quiz Name',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 1,
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _quizData['questions_list'].length,
                      itemBuilder: (context, index) {
                        final question = _quizData['questions_list'][index];
                        final options =
                            question['options'] as Map<String, dynamic>;
                        return Column(
                          children: [
                            Container(
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    16), // Increased padding
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Question ${index + 1}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20, // Increased font size
                                            color: Colors
                                                .blue, // Changed color to blue
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                _showQuestionDialog(
                                                    question: question,
                                                    index: index);
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () {
                                                setState(() {
                                                  _quizData['questions_list']
                                                      .removeAt(index);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      question['question'] ?? '',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 10),
                                    ...options.entries.map((option) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Text(
                                          '${option.key}: ${option.value}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      );
                                    }).toList(),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Correct Option: ${question['correctOption']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors
                                            .green, // Changed color to green
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (index != _quizData['questions_list'].length - 1)
                              const Divider(
                                color: Colors.grey,
                                height: 1,
                                thickness: 1,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (_isPosting)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: LoadingScreen(),
                ),
              ),
          ],
        ),
      ),
     bottomNavigationBar: Container(
  height: 70,
  decoration: BoxDecoration(
    color:Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 5,
        offset: const Offset(0, 3),
      ),
    ],
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      ElevatedButton(
        onPressed: _isPosting ? null : _showQuestionDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Button background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Add Question',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Button text color
            ),
          ),
        ),
      ),
      ElevatedButton(
        onPressed: _isPosting ? null : _postData,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green, // Button background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            widget.quizData != null && widget.quizData!['_id'] != null
                ? 'Update Quiz'
                : 'Create Quiz',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Button text color
            ),
          ),
        ),
      ),
    ],
  ),
),

    );
  }
}
