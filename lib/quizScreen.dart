import 'dart:async';

import 'package:flutter/material.dart';

class QuizApp extends StatefulWidget {
  @override
  _QuizAppState createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  int _currentIndex = 0;
  int _score = 0;
  List<Question> _questions = [
    Question('What is the capital city of France?',
        ['Madrid', 'Paris', 'Rome', 'Berlin'], 1),
    Question('Which planet is closest to the sun?',
        ['Mercury', 'Venus', 'Mars', 'Jupiter'], 0),
    Question('What is the tallest mountain in the world?',
        ['Everest', 'K2', 'Kangchenjunga', 'Lhotse'], 0),
  ];

  void _answerQuestion(int answerIndex) {
    if (_currentIndex < _questions.length) {
      if (_questions[_currentIndex].correctAnswerIndex == answerIndex) {
        setState(() {
          _score++;
        });
      }
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.logout),
            ),
          ],
          title: Text('Quiz App'),
        ),
        body: Center(
          child: _currentIndex < _questions.length
              ? QuizQuestion(
                  question: _questions[_currentIndex],
                  answerQuestion: _answerQuestion,
                  onTimeLimitReached: () {
                    setState(() {
                      _currentIndex++;
                    });
                  },
                )
              : QuizResult(
                  score: _score,
                  totalQuestions: _questions.length,
                  restartQuiz: _restartQuiz,
                ),
        ),
      ),
    );
  }
}

class QuizQuestion extends StatefulWidget {
  final Question question;
  final Function answerQuestion;
  final Function onTimeLimitReached;

  QuizQuestion({
    required this.question,
    required this.answerQuestion,
    required this.onTimeLimitReached,
  });

  @override
  State<QuizQuestion> createState() => _QuizQuestionState();
}

class _QuizQuestionState extends State<QuizQuestion> {
  int _selectedAnswerIndex = -1;
  late Timer _timer;
  int _remainingTime = 10;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime--;
      });
      if (_remainingTime == 0) {
        setState(() {
          _onTimeLimitReached();
        });
      }
    });
  }

  void _onTimeLimitReached() {
    _selectedAnswerIndex = -1;
    widget.onTimeLimitReached();
    _remainingTime = 10;
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.question.questionText,
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20),
        Text(
          'Time Remaining: $_remainingTime',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
        ...widget.question.answers
            .asMap()
            .entries
            .map(
              (answer) => SizedBox(
                width: 300,
                child: ElevatedButton(
                  child: Text(answer.value),
                  onPressed: () => setState(() {
                    _selectedAnswerIndex = answer.key;
                  }),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      _selectedAnswerIndex == answer.key
                          ? Colors.green
                          : Colors.blue,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
        SizedBox(height: 20),
        ElevatedButton(
          child: Text('Submit Answer'),
          onPressed: _selectedAnswerIndex == -1
              ? null
              : () => widget.answerQuestion(_selectedAnswerIndex),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              _selectedAnswerIndex == -1
                  ? Colors.grey
                  : Color.fromARGB(255, 192, 151, 61),
            ),
          ),
        )
      ],
    );
  }
}

class QuizResult extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final Function restartQuiz;

  QuizResult(
      {required this.score,
      required this.totalQuestions,
      required this.restartQuiz});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Quiz Complete!',
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20),
        Text(
          'You scored $score out of $totalQuestions.',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          child: Text('Restart Quiz'),
          onPressed: () => restartQuiz(),
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Color.fromARGB(255, 37, 126, 106))),
        )
      ],
    );
  }
}

class Question {
  final String questionText;
  final List<String> answers;
  final int correctAnswerIndex;

  Question(this.questionText, this.answers, this.correctAnswerIndex);
}
