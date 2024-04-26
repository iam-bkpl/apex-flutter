import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:question_answer_app/question_engine.dart';

QuestionEngine questionEngine = QuestionEngine();

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int score = 0;

  List<Widget> recordTracker = [];

  Future<void> _showDialog(
      String title, String bodyText, String buttonText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(title),
              Text(bodyText),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  Navigator.pop(context, 'OK');
                  questionEngine.reset();
                });
              },
              child: Text(buttonText)),
        ],
      ),
    );
  }

  void checkAnswer(String userSelectedAnswer, int weightValue) {
    String correctAnswer = questionEngine.getCorrectAnswer();

    setState(() {
      // first test: check if the quiz is finished
      if (questionEngine.didFinishQuiz()) {
        _showDialog("Congratulations", "You have come to the end of the quiz",
            "Start Again");
        questionEngine.reset();
        score = 0;
        recordTracker = [];
      } else {
        if (userSelectedAnswer == correctAnswer) {
          recordTracker.add(
            const Icon(
              Icons.check_box,
              color: Colors.green,
              size: 30,
            ),
          );
        } else {
          recordTracker.add(
            const Icon(
              Icons.close,
              color: Colors.red,
              size: 30,
            ),
          );
        }
        score += weightValue;
      }
      questionEngine.nextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(
                questionEngine.getQuestionTextForCurrentQuestion(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 25.0, color: Colors.white),
              ),
            ),
          ),
        ),
        ListView.builder(
            itemCount: 4,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: MaterialButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      questionEngine.getAnswers()[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  onPressed: () {
                    //The user picked this answer.
                    setState(() {
                      checkAnswer(questionEngine.getAnswers()[index], questionEngine.getScoreFromAnswers()[index]);
                    });
                  },
                ),
              );
            }),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            children: [
              const Text(
                'Score: ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 20),
              ),
              Text(
                '$score',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
              const Padding(padding: EdgeInsets.only(right: 15)),
              ...recordTracker
            ],
          ),
        )
      ],
    );
  }
}
