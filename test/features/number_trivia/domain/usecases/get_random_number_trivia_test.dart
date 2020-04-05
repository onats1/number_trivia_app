import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:numbertriviaapp/core/usecases/usecase.dart';
import 'package:numbertriviaapp/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbertriviaapp/number_trivia/domain/repositories/num_trivia_repo.dart';
import 'package:numbertriviaapp/number_trivia/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumberTrivia = NumberTrivia(number: 1, text: "test");

  test("should get random trivia from the repository", () async{

    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(tNumberTrivia));

    var result = await usecase(NoParams());

    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}