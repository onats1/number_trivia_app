import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:numbertriviaapp/core/errors/exceptions.dart';
import 'package:numbertriviaapp/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:numbertriviaapp/number_trivia/data/models/number_trivia_model.dart';
import 'package:matcher/matcher.dart';
import '../../../../core/constants.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSourceImpl;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSourceImpl = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockeHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setupMockHttpClientFailure404(){
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Someting went wrong', 404));
  }

  group("getConcreteNumberTrivia", () {
    final tNumber = 1;
    final tNumberTrivialModel =
    NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''Should perform a get request on a url with the number
         being the endpoint and with application/json header''', () async {
      setUpMockeHttpClientSuccess200();

      dataSourceImpl.getConcreteNumberTrivia(tNumber);

      verify(mockHttpClient.get('${Constants.REMOTE_URL}/$tNumber',
          headers: {'Content-Type': 'application/json'}));
    });

    test('Should return NumberTrivia when the response code is 200', () async {
      setUpMockeHttpClientSuccess200();

      final result = await dataSourceImpl.getConcreteNumberTrivia(tNumber);

      expect(result, equals(tNumberTrivialModel));
    });

    test('Should throw ServerException if resposecode is not 200', () async {
      setupMockHttpClientFailure404();

      final call = dataSourceImpl.getConcreteNumberTrivia;

      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group("getRandomNumberTrivia", () {

    final tNumber = 1;
    final tNumberTrivialModel =
    NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''Should perform a get request on a url with the number
         being the endpoint and with application/json header''', () async {
      setUpMockeHttpClientSuccess200();

      dataSourceImpl.getRandomNumberTrivia();

      verify(mockHttpClient.get('${Constants.REMOTE_URL}/random',
          headers: {'Content-Type': 'application/json'}));
    });

    test('Should return NumberTrivia when the response code is 200', () async {
      setUpMockeHttpClientSuccess200();
      final result = await dataSourceImpl.getRandomNumberTrivia();

      expect(result, equals(tNumberTrivialModel));
    });

    test('Should throw ServerException if resposecode is not 200', () async {
      setupMockHttpClientFailure404();

      final call = dataSourceImpl.getRandomNumberTrivia;

      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
