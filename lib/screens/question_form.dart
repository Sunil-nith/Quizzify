import 'package:flutter/material.dart';

class QuestionForm extends StatefulWidget {
  final Map<String, dynamic>? question;
  const QuestionForm({super.key, this.question});
  @override
  State<QuestionForm> createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  TextEditingController questionController = TextEditingController();
  TextEditingController option1Controller = TextEditingController();
  TextEditingController option2Controller = TextEditingController();
  TextEditingController option3Controller = TextEditingController();
  TextEditingController option4Controller = TextEditingController();
  String correctOption = '1';

  @override
  void initState() {
    super.initState();
    if (widget.question != null) {
      questionController.text = widget.question!['question'];
      option1Controller.text = widget.question!['options']['1'];
      option2Controller.text = widget.question!['options']['2'];
      option3Controller.text = widget.question!['options']['3'];
      option4Controller.text = widget.question!['options']['4'];
      correctOption = widget.question!['correctOption'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.question == null ? 'Add Question' : 'Edit Question',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: questionController,
                decoration: const InputDecoration(labelText: 'Question'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: option1Controller,
                decoration: const InputDecoration(labelText: 'Option 1'),
              ),
              TextField(
                controller: option2Controller,
                decoration: const InputDecoration(labelText: 'Option 2'),
              ),
              TextField(
                controller: option3Controller,
                decoration: const InputDecoration(labelText: 'Option 3'),
              ),
              TextField(
                controller: option4Controller,
                decoration: const InputDecoration(labelText: 'Option 4'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    'Correct Option : ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  DropdownButton<String>(
                    value: correctOption,
                    onChanged: (String? newValue) {
                      setState(() {
                        correctOption = newValue!;
                      });
                    },
                    items: <String>['1', '2', '3', '4']
                        .map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveQuestion,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 4,
                    shadowColor: Colors.grey.withOpacity(0.5),
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveQuestion() {
    if (questionController.text.isEmpty ||
        option1Controller.text.isEmpty ||
        option2Controller.text.isEmpty ||
        option3Controller.text.isEmpty ||
        option4Controller.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('All fields are required.'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
    Navigator.pop(context, {
      "question": questionController.text,
      "options": {
        "1": option1Controller.text,
        "2": option2Controller.text,
        "3": option3Controller.text,
        "4": option4Controller.text,
      },
      "correctOption": correctOption,
    });
  }
}
