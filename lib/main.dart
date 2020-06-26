import 'package:flutter/material.dart';
import 'package:quizzler/question.dart';

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];

  List<Question> questionBank = [
    Question(
      text: 'You can lead a cow down stairs but not up stairs.',
      answer: false,
    ),
    Question(
      text: 'Approximately one quarter of human bones are in the feet.',
      answer: true,
    ),
    Question(
      text: 'A slug\'s blood is green.',
      answer: true,
    ),
  ];

  int questionNumber = 0;

  void _answer(bool answer) {
    bool correctAnswer = questionBank[questionNumber].answer;
    if (answer == correctAnswer) {
      _addCorrect();
    } else {
      _addWrong();
    }
    _incrementQuestionNumber();
  }

  void _addCorrect() {
    setState(() {
      scoreKeeper.add(Icon(
        Icons.check,
        color: Colors.green,
      ));
    });
  }

  void _addWrong() {
    setState(() {
      scoreKeeper.add(Icon(
        Icons.close,
        color: Colors.red,
      ));
    });
  }

  void _incrementQuestionNumber() {
    setState(() {
      if (this.questionNumber >= this.questionBank.length - 1)
        this.questionNumber = 0;
      else
        this.questionNumber++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 30,
          child: Row(
            children: scoreKeeper,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                this.questionBank[this.questionNumber].text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 100,
                child: FlatButton(
                  color: Colors.blue[600],
                  child: Text(
                    'True',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: () => _answer(true),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                height: 100,
                child: FlatButton(
                  color: Colors.blue[600],
                  child: Text(
                    'False',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => _answer(false),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
