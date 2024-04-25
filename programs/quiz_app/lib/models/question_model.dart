class QuestionDatabase {
  final int id;
  final String question;

  QuestionDatabase({required this.id, required this.question});
}

class AnswerDatabase {
  final int id;
  final String text;
  final bool correct;

  AnswerDatabase({
    required this.id,
    required this.text,
    required this.correct,
  });
}

//  {
//       "question": "What is the purpose of a VPN?",
//       "answers": [
//         {"id": 1, "text": "Secure remote access", "correct": true},
//         {"id": 2, "text": "Speed up internet", "correct": false},
//         {"id": 3, "text": "Protect against viruses", "correct": false},
//         {"id": 4, "text": "Improve website performance", "correct": false}
//       ]
//     },