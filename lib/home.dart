import 'package:flutter/material.dart';
import 'answer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Icon> _scoreTracker = [];
  int _questionIndex = 0;
  int _totalScore = 0;
  bool answerWasSelected = false;
  bool endOfQuiz = false;
  bool correctAnswerSelected = false;

  void _questionAnswered(bool answerScore) {
    setState(() {
      answerWasSelected = true;
      if (answerScore) {
        _totalScore++;
        correctAnswerSelected = true;
      }
      _scoreTracker.add(
        answerScore
            ? const Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            : const Icon(
                Icons.clear,
                color: Colors.red,
              ),
      );
      if (_questionIndex + 1 == _questions.length) {
        endOfQuiz = true;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _questionIndex++;
      answerWasSelected = false;
      correctAnswerSelected = false;
    });
    if (_questionIndex >= _questions.length) {
      _resetQuiz();
    }
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
      _scoreTracker = [];
      endOfQuiz = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Cricket Quiz App',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                if (_scoreTracker.length == 0)
                  const SizedBox(
                    height: 25.0,
                  ),
                if (_scoreTracker.length > 0) ..._scoreTracker
              ],
            ),
            Container(
              width: double.infinity,
              height: 130.0,
              margin:
                  const EdgeInsets.only(bottom: 10.0, left: 30.0, right: 30.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  _questions[_questionIndex]['question'].toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ...(_questions[_questionIndex]['answers']
                    as List<Map<String, Object>>)
                .map(
              (answer) => Answer(
                answerText: answer['answerText'].toString(),
                answerColor: answerWasSelected
                    ? (answer['score'] as bool? ?? false)
                        ? Colors.green
                        : Colors.red
                    : Colors.transparent,
                answerTap: () {
                  if (answerWasSelected) {
                    return;
                  }
                  _questionAnswered(answer['score'] as bool);
                },
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40.0),
              ),
              onPressed: () {
                if (!answerWasSelected) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        'Please select an answer before going to the next question'),
                    backgroundColor: Colors.black,
                  ));
                  return;
                }
                _nextQuestion();
              },
              child: Text(endOfQuiz ? 'Restart Quiz' : 'Next Question'),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                '${_totalScore.toString()}/${_questions.length}',
                style: const TextStyle(
                    fontSize: 40.0, fontWeight: FontWeight.bold),
              ),
            ),
            if (answerWasSelected && !endOfQuiz)
              Container(
                height: 100,
                width: double.infinity,
                color: correctAnswerSelected ? Colors.green : Colors.red,
                child: Center(
                  child: Text(
                    correctAnswerSelected
                        ? 'Well done, you got it right!'
                        : 'Wrong :/',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (endOfQuiz)
              Container(
                height: 100,
                width: double.infinity,
                color: Colors.black,
                child: Center(
                  child: Text(
                    _totalScore > 4
                        ? 'Congratulations! Your final score is: $_totalScore'
                        : 'Your final score is: $_totalScore. Better luck next time !',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: _totalScore > 4 ? Colors.green : Colors.red,
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

const _questions = [
  {
    'question': 'Who is the ICC Best Cricketer of the Year 2019?',
    'answers': [
      {'answerText': 'Ben Stokes', 'score': true},
      {'answerText': 'Kane Williamson', 'score': false},
      {'answerText': 'Ms.Dhoni', 'score': false},
      {'answerText': 'Rohit Sharma', 'score': false},
    ],
  },
  {
    'question':
        'Which Indian Cricketer became the fastest batsman in the world to reach 20,000 international runs mark?',
    'answers': [
      {'answerText': 'Ricky Ponting', 'score': false},
      {'answerText': 'Sachin Tendulkar', 'score': false},
      {'answerText': 'Virat Kohli', 'score': true},
      {'answerText': 'Adam Gilchrist', 'score': false},
    ],
  },
  {
    'question':
        'Who become the first cricketer to win three top ICC honours in the same year??',
    'answers': [
      {'answerText': 'Kane Williamson', 'score': false},
      {'answerText': 'Brendon Mccullam', 'score': false},
      {'answerText': 'Chris Gayle', 'score': false},
      {'answerText': 'Virat Kohli', 'score': true},
    ],
  },
  {
    'question': 'The 1975 World Cup, the first of its kind was played at?',
    'answers': [
      {'answerText': 'Christchurch', 'score': false},
      {'answerText': 'Eden Garden', 'score': false},
      {'answerText': 'Lords London', 'score': true},
      {'answerText': 'Chinnaswamy', 'score': false},
    ],
  },
  {
    'question': 'Who won the first World Cup, 1975?',
    'answers': [
      {'answerText': 'West indies', 'score': true},
      {'answerText': 'Australia', 'score': false},
      {'answerText': 'NewZealand', 'score': false},
      {'answerText': 'India', 'score': false},
    ],
  },
  {
    'question': 'What is New Zealand cricketer Brendon McCullum nickname?',
    'answers': [
      {'answerText': 'Bazz', 'score': true},
      {'answerText': 'Cheekku', 'score': false},
      {'answerText': 'Bary', 'score': false},
      {'answerText': 'Willy', 'score': false},
    ],
  },
  {
    'question': 'Capital Of Newzealand?',
    'answers': [
      {'answerText': 'Wellington', 'score': true},
      {'answerText': 'Paris', 'score': false},
      {'answerText': 'Christchurch', 'score': false},
      {'answerText': 'Auckland', 'score': false},
    ],
  },
  {
    'question': 'Who is known as father of cricket?',
    'answers': [
      {'answerText': 'Chaminda Vaas', 'score': false},
      {'answerText': 'Chandrapaul', 'score': false},
      {'answerText': 'Vivain Richardson', 'score': false},
      {'answerText': 'William Gilbret Grace', 'score': true},
    ],
  },
  {
    'question': 'Which Is the Home Ground of Cricket?',
    'answers': [
      {'answerText': 'Mohali', 'score': false},
      {'answerText': 'Christchurch', 'score': false},
      {'answerText': 'GreenField', 'score': false},
      {'answerText': 'Lords London', 'score': true},
    ],
  },
  {
    'question': '1992 world cup held in?',
    'answers': [
      {'answerText': 'Mohali', 'score': false},
      {'answerText': 'Brisbane', 'score': false},
      {'answerText': 'Christchurch', 'score': false},
      {'answerText': 'Australia and New Zealand', 'score': true},
    ],
  },
];
