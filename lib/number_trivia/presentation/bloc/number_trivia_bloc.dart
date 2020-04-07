
import 'package:numbertriviaapp/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:bloc/bloc.dart';

import 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState>{
  @override
  // TODO: implement initialState
  NumberTriviaState get initialState => null;

  @override
  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event) async* {
    // TODO: implement mapEventToState
    yield null;
  }

}