
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:numbertriviaapp/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaState extends Equatable {
  NumberTriviaState([List props = const <dynamic>[]]) : super(props);
}

class InitialState extends NumberTriviaState{}

class Loading extends NumberTriviaState{}

class Data extends NumberTriviaState{
  final NumberTrivia trivia;

  Data({@required this.trivia}): super([trivia]);
}

class Error extends NumberTriviaState{
  final String message;

  Error({@required this.message}): super([message]);
}