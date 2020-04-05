
import 'package:numbertriviaapp/number_trivia/data/models/number_trivia_model.dart';

//Calls the remote endpoint and throws a server exception for all error codes
abstract class NumberTriviaRemoteDataSource{
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}