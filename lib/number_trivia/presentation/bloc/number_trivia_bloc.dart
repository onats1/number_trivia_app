import 'package:flutter/cupertino.dart';
import 'package:numbertriviaapp/core/constants.dart';
import 'package:numbertriviaapp/core/errors/failures.dart';
import 'package:numbertriviaapp/core/presentation/util/input_converter.dart';
import 'package:numbertriviaapp/core/usecases/usecase.dart';
import 'package:numbertriviaapp/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbertriviaapp/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numbertriviaapp/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:bloc/bloc.dart';

import 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {@required GetConcreteNumberTrivia concrete,
      @required GetRandomNumberTrivia random,
      @required InputConverter input})
      : assert(concrete != null),
        assert(random != null),
        assert(input != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        inputConverter = input;

  @override
  // TODO: implement initialState
  NumberTriviaState get initialState => InitialState();

  @override
  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event) async* {
    if (event is GetConcreteNumberEvent) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      yield* inputEither.fold((failure) async* {
        yield Error(message: Constants.INVALID_INPUT_FAILURE_MESSAGE);
        // ignore: missing_return
      }, (integer) async* {
        yield Loading();
        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: integer));
        yield failureOrTrivia.fold(
            (failure) => Error(message: _switchFaliuretoString(failure)),
            (trivia) => Data(trivia: trivia));
      });
    } else if (event is GetRandomNumberEvent){

      yield Loading();
      final resultEither = await getRandomNumberTrivia(NoParams());

      yield resultEither.fold((failure) => Error(message: _switchFaliuretoString(failure)),
          (trivia) => Data(trivia: trivia));
    }
  }

  String _switchFaliuretoString(Failures failiure){
    switch (failiure.runtimeType) {
      case ServerFailure:
        return Constants.SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return Constants.CACHE_FAILURE_MESSAGE;
      default:
        return "Unknown error";
    }
  }
}
