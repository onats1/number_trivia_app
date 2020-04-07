
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:numbertriviaapp/core/errors/failures.dart';
import 'package:numbertriviaapp/core/presentation/util/input_converter.dart';

void main(){
  InputConverter inputConverter;

  setUp((){
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', (){
    test("Should return int when the string contains an integer value", (){

      final stringNumber = "123";

      final result = inputConverter.stringToUnsignedInteger(stringNumber);

      expect(result, Right(123));
    });

    test("Return a failure when the string is not an integer", (){

      final stringNumber = "not an integer";

      final result = inputConverter.stringToUnsignedInteger(stringNumber);

      expect(result, Left(InvalidInputFailure()));
    });

    test("Return a failure when the string is a negative integer", (){

      final stringNumber = "-123";

      final result = inputConverter.stringToUnsignedInteger(stringNumber);

      expect(result, Left(InvalidInputFailure()));
    });


  });
}