import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:numbertriviaapp/core/errors/failures.dart';

abstract class UseCase<Type, Params>{

  Future<Either<Failures, Type>> call(Params params);
}

class NoParams extends Equatable {}