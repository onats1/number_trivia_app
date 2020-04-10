import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:numbertriviaapp/core/errors/failures.dart';
import 'package:numbertriviaapp/core/presentation/util/input_converter.dart';
import 'package:numbertriviaapp/core/usecases/usecase.dart';
import 'package:numbertriviaapp/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbertriviaapp/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbertriviaapp/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numbertriviaapp/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:numbertriviaapp/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:numbertriviaapp/number_trivia/presentation/bloc/number_trivia_state.dart';

import '../../../../core/constants.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc numberTriviaBloc;
  MockGetConcreteNumberTrivia getConcreteNumberTrivia;
  MockGetRandomNumberTrivia getRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    getConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    getRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    numberTriviaBloc = NumberTriviaBloc(
        concrete: getConcreteNumberTrivia,
        random: getRandomNumberTrivia,
        input: mockInputConverter);
  });

  test("Initial State should be empty", () {
    expect(numberTriviaBloc.initialState, equals(InitialState()));
  });

  group("GetTriviaForConcreteNumber", () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: "test trivia");



    test(
        "Should call the input converter to validate and convert the string to an unsigned integer",
        () async {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));

      numberTriviaBloc.dispatch(GetConcreteNumberEvent(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test("Should emit [Error] when the input is invalid", () async {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

      final expected = [
        InitialState(),
        Error(message: Constants.INVALID_INPUT_FAILURE_MESSAGE)
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expected));

      numberTriviaBloc.dispatch(GetConcreteNumberEvent(tNumberString));
    });

    test("Should get data from the concrete use case", () async {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));

      when(getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      numberTriviaBloc.dispatch(GetConcreteNumberEvent(tNumberString));
      await untilCalled(getConcreteNumberTrivia(any));

      verify(getConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test("should emit [Loading, Data] when data is gotten successful", () async {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
      when(getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      final expected = [
        InitialState(),
        Loading(),
        Data(trivia: tNumberTrivia)
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expected));

      numberTriviaBloc.dispatch(GetConcreteNumberEvent(tNumberString));

    });

    test("should emit [Loading, Error] when getting data fails", () async {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
      when(getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        InitialState(),
        Loading(),
        Error(message: Constants.SERVER_FAILURE_MESSAGE)
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expected));

      numberTriviaBloc.dispatch(GetConcreteNumberEvent(tNumberString));

    });

    test("should emit [Loading, Error] with a proper message when getting data fails", () async {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
      when(getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        InitialState(),
        Loading(),
        Error(message: Constants.CACHE_FAILURE_MESSAGE)
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expected));

      numberTriviaBloc.dispatch(GetConcreteNumberEvent(tNumberString));

    });
  });

  group("GetTriviaForRandomNumber", () {
    final tNoParams = NoParams();
    final tNumberTrivia = NumberTrivia(number: 1, text: "test trivia");

    test("Should get data from the random use case", () async {

      when(getRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      numberTriviaBloc.dispatch(GetRandomNumberEvent());
      await untilCalled(getRandomNumberTrivia(any));

      verify(getRandomNumberTrivia(tNoParams));
    });

    test("should emit [Loading, Data] when data is gotten successful", () async {

      when(getRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      final expected = [
        InitialState(),
        Loading(),
        Data(trivia: tNumberTrivia)
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expected));

      numberTriviaBloc.dispatch(GetRandomNumberEvent());

    });

    test("should emit [Loading, Error] when getting data fails", () async {

      when(getRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        InitialState(),
        Loading(),
        Error(message: Constants.SERVER_FAILURE_MESSAGE)
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expected));

      numberTriviaBloc.dispatch(GetRandomNumberEvent());

    });

    test("should emit [Loading, Error] with a proper message when getting data fails", () async {

      when(getRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        InitialState(),
        Loading(),
        Error(message: Constants.CACHE_FAILURE_MESSAGE)
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expected));

      numberTriviaBloc.dispatch(GetRandomNumberEvent());

    });
  });
}
