import 'package:flutter/material.dart';
import 'package:quiz_app/components/my_button.dart';
import 'package:quiz_app/data/question_data.dart';
import 'package:quiz_app/data/report_data.dart';
import 'package:quiz_app/pages/question.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  int score = 0;

  // final Map<String, String> _selectedAnswers = [];

  final List<Map<String, dynamic>> _questions = QuestionData.getQuestions();
  ReportData reportData = ReportData();

  void handleSave(BuildContext context) {
    final List _reports = reportData.getReport();

    print(_reports);

    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Question(question: "$score / ${_questions.length}"),
            const SizedBox(
              height: 20,
            ),
            ..._reports.map((report) {
              IconData iconData = report["correct"] ? Icons.check : Icons.close;
              return Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      report["question"].toString(),
                      style: const TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                    Icon(iconData),
                  ],
                ),
              );
            }),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              text: "Close",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void handleQuestionChange(BuildContext context, correct) {
    if (currentIndex < _questions.length - 1) {
      setState(() {
        currentIndex += 1;
      });

      // increase score if correct
      if (correct) {
        setState(() {
          score += 1;
        });
      }

      // store data
      reportData.addReport(_questions[currentIndex]["question"], correct);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.done),
          title: Text("You Scored $score / ${_questions.length}"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.all(10),
          actions: [
            ElevatedButton(
              onPressed: () {
                handleReset(context);
                Navigator.pop(context);
              },
              child: const Text("Restart"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
            ElevatedButton(
              onPressed: () => handleSave(context),
              child: const Text("View Report"),
            )
          ],
        ),
      );
    }
  }

  void handleReset(BuildContext context) {
    setState(() {
      currentIndex = 0;
      score = 0;
    });
    reportData.deleteReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text("Quiz app"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Question no ${currentIndex + 1} / ${_questions.length}",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 30,
            ),
            Question(
              question: _questions[currentIndex]["question"].toString(),
            ),
            const SizedBox(
              height: 10,
            ),
            // ...(_questions[currentIndex]['answers'] as List <
            //         Map<String, Object>)
            //     .map((answer) {
            //   return MyButton(
            //     text: answer.toString(),
            //     onPressed: () => handleQuestionChange(context),
            //   );
            // }).toList(),

            ...(_questions[currentIndex]['answers']
                        as List<Map<String, Object>>?)
                    ?.map((answer) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: MyButton(
                      text: answer['text']
                          .toString(), // Accessing the 'text' field of the answer map
                      onPressed: () =>
                          handleQuestionChange(context, answer["correct"]),
                    ),
                  );
                }).toList() ??
                [],

            const SizedBox(
              height: 40,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MyButton(
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  text: "Reset",
                  onPressed: () => handleReset(context),
                ),
                MyButton(
                  text: "Save",
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  onPressed: () => handleSave(context),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text("Current Score : ${score.toString()}"),
          ],
        ),
      ),
    );
  }
}
