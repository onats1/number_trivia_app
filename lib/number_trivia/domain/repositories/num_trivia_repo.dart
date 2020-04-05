import 'package:dartz/dartz.dart';
import 'package:numbertriviaapp/core/errors/failures.dart';
import 'package:numbertriviaapp/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failures, NumberTrivia>> getConcreteNumberTrivia(int number);

  Future<Either<Failures, NumberTrivia>> getRandomNumberTrivia();
}
