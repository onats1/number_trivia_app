import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:numbertriviaapp/core/errors/exceptions.dart';
import 'package:numbertriviaapp/core/errors/failures.dart';
import 'package:numbertriviaapp/core/network/network_info.dart';
import 'package:numbertriviaapp/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:numbertriviaapp/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:numbertriviaapp/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbertriviaapp/number_trivia/domain/repositories/num_trivia_repo.dart';

typedef Future<NumberTrivia> _ConcreteOrRandom();

class NumberTriviaRepositoryImpl extends NumberTriviaRepository {
  final NumberTriviaRemoteDataSource numberTriviaRemoteDataSource;
  final NumberTriviaLocalDataSource numberTriviaLocalDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {@required this.numberTriviaLocalDataSource,
      @required this.numberTriviaRemoteDataSource,
      @required this.networkInfo});

  @override
  Future<Either<Failures, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
   return await _getTrivia((){
     return numberTriviaRemoteDataSource.getConcreteNumberTrivia(number);
   });
  }

  @override
  Future<Either<Failures, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia((){
      return numberTriviaRemoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failures, NumberTrivia>> _getTrivia(
      _ConcreteOrRandom getRandomOrConcreteNumber) async {

    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia =
            await getRandomOrConcreteNumber();
        numberTriviaLocalDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia =
            await numberTriviaLocalDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }

  }
}
