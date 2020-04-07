
import 'package:dartz/dartz.dart';
import 'package:numbertriviaapp/core/errors/failures.dart';

class InputConverter{
  Either<Failures, int> stringToUnsignedInteger(String str){
    try{
      final integerValue = int.parse(str);

      if (integerValue<0){
        throw FormatException();
      } else {
        return Right(integerValue);
      }
    } on FormatException{
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failures{

}