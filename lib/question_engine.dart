import 'question.dart';

class QuestionEngine {
  int _questionNumber = 0;
  int correctAnswers = 0;

  final List<Question> _questionList = [
    Question(
      'What is the capital of France?',
      ['Berlin', 'Madrid', 'Paris', 'Rome'],
      'Paris',
      [-1,-1,2,-1],
    ),
    Question(
      'Which planet is known as the Red Planet?',
      ['Mars', 'Jupiter', 'Venus', 'Mercury'],
      'Mars',
      [2,-1,-1,-1],
    ),
    Question(
      'Who wrote "Romeo and Juliet"?',
      ['William Shakespeare', 'Charles Dickens', 'Jane Austen', 'Mark Twain'],
      'William Shakespeare',
      [2,-1,-1,-1],
    ),
    Question(
      'What is the largest mammal?',
      ['Elephant', 'Blue whale', 'Giraffe', 'Polar bear'],
      'Blue whale',
      [-1,2,-1,-1],
    ),
    Question(
      'What is the chemical symbol for gold?',
      ['Ag', 'Au', 'Hg', 'Fe'],
      'Au',
      [-1,2,-1,-1],
    ),
    Question(
      'What is the currency of Japan?',
      ['Yen', 'Won', 'Dollar', 'Euro'],
      'Yen',
      [2,-1,-1,-1],
    ),
    Question(
      'Who is known as the "Father of Modern Physics"?',
      ['Albert Einstein', 'Isaac Newton', 'Galileo Galilei', 'Nikola Tesla'],
      'Albert Einstein',
      [2,-1,-1,-1],
    ),
    Question(
      'What is the smallest prime number?',
      ['0', '1', '2', '3'],
      '2',
      [-1,-1,2,-1],
    ),
    Question(
      'Which country is known as the Land of the Rising Sun?',
      ['China', 'South Korea', 'Japan', 'Thailand'],
      'Japan',
      [-1,-1,2,-1],
    ),
    Question(
      'What is the chemical symbol for water?',
      ['H2O', 'CO2', 'O2', 'N2'],
      'H2O',
      [2,-1,-1,-1],
    ),
  ];

  int getQuestionsCount() {
    return _questionList.length;
  }

  void nextQuestion() {
    if(_questionNumber < _questionList.length - 1) {
      _questionNumber++;
    }
  }

  String getQuestionTextForCurrentQuestion() {
    return _questionList[_questionNumber].questionText;
  }

  List<String> getAnswers() {
    return _questionList[_questionNumber].answersList;
  }

  List<int> getScoreFromAnswers() {
    return _questionList[_questionNumber].answerWeight;
  }

  String getCorrectAnswer() {
    return _questionList[_questionNumber].correctAnswer;
  }

  bool didFinishQuiz() {
    return _questionNumber >= _questionList.length - 1;
  }

  void reset() {
    _questionNumber = 0;
  }

}