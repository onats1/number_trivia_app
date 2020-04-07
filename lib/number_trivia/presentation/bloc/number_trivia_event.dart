
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NumberTriviaEvent extends Equatable{
  NumberTriviaEvent([List props = const <dynamic> []]): super(props);
}

class GetConcreteNumberEvent extends NumberTriviaEvent{

  final String numberString;
  GetConcreteNumberEvent(this.numberString): super([numberString]);
}

class GetRandomNumberEvent extends NumberTriviaEvent{}