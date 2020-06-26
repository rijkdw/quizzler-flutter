import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzler/question.dart';
import 'package:quizzler/quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = QuizBrain();

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

class ResultIcon extends StatelessWidget {
  final Question question;
  final bool answeredCorrectly;

  ResultIcon({this.question, this.answeredCorrectly});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.5,
      alignment: Alignment.center,
//      color: answeredCorrectly ? Colors.green[900] : Colors.red[900],
      child: InkWell(
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Icon(
          answeredCorrectly ? Icons.check : Icons.close,
          color: answeredCorrectly ? Colors.green : Colors.red,
        ),
        onTap: () {
          Alert(
            context: context,
            type: answeredCorrectly ? AlertType.success : AlertType.error,
            style: AlertStyle(
              isCloseButton: false,
            ),
            title: answeredCorrectly ? "Correct" : "Incorrect",
            desc: "${this.question.text}\n\nThe correct answer is ${this.question.answer.toString().toUpperCase()}",
            buttons: [
              DialogButton(
                child: Text(
                  "Close",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                width: 120,
              )
            ],
          ).show();
        },
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Widget> scoreKeeper = [];
  int numCorrect = 0;
  int numAsked = 0;

  List<Widget> _fillUpScoreKeeper() {
    List<Widget> returnList = [];
    returnList.addAll(scoreKeeper);
    for (int i = returnList.length; i < quizBrain.getNumQuestions(); i++) {
      returnList.add(
        Container(
          width: 24.5,
          alignment: Alignment.center,
          child: Text(
            '?',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          )
        ),
      );
    }
    return returnList;
  }

  void _reset() {
    setState(() {
      quizBrain.reset();
      this.scoreKeeper = [];
      this.numCorrect = 0;
      this.numAsked = 0;
    });
  }

  void _answer(bool answer) {
    bool correctAnswer = quizBrain.getQuestionAnswer();
    if (answer == correctAnswer) {
      setState(() {
        scoreKeeper.add(ResultIcon(
          answeredCorrectly: true,
          question: quizBrain.getQuestion(),
        ));
      });
      numCorrect++;
    } else {
      setState(() {
        scoreKeeper.add(ResultIcon(
          answeredCorrectly: false,
          question: quizBrain.getQuestion(),
        ));
      });
    }
    numAsked++;
    setState(() {
      quizBrain.nextQuestion();
    });
    if (!quizBrain.hasNext()) {
      Alert(
        context: context,
        type: AlertType.success,
        style: AlertStyle(
          isCloseButton: false,
        ),
        title: "Congrats!",
        desc: "You scored $numCorrect/$numAsked.",
        buttons: [
          DialogButton(
            child: Text(
              "Try again",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              this._reset();
              Navigator.pop(context);
            },
            width: 120,
          )
        ],
      ).show();
    }
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
            children: _fillUpScoreKeeper(),
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
                quizBrain.getQuestionText(),
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
                  color: Colors.green[600],
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
                  color: Colors.red[600],
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
