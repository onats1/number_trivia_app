import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numbertriviaapp/core/errors/exceptions.dart';
import 'package:numbertriviaapp/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:numbertriviaapp/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';
import '../../../../core/constants.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences{}

void main(){

  NumberTriviaLocalDataSourceImpl localDataSourceImpl;
  MockSharedPreferences mockSharedPreferences;

  setUp((){
    mockSharedPreferences = MockSharedPreferences();
    localDataSourceImpl = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group("getLastNumberTrivia", ()  {

    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('cache_trivia.json')));

    test("Should return number trivia from shared preferences when present in cache", () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('cache_trivia.json'));

      final result = await localDataSourceImpl.getLastNumberTrivia();
      verify(mockSharedPreferences.getString(Constants.GET_CACHED_DATA_TAG));

      expect(result, tNumberTriviaModel);
    });

    test("Should throw cache exception when cache is empty", () {
      when(mockSharedPreferences.getString(any))
          .thenReturn(null);

      final call = localDataSourceImpl.getLastNumberTrivia;

      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("Cache number trivia", (){
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "test trivia");

    test("Should call sharedpreferences to cach the data", (){

      localDataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);

      final expectedString = json.encode(tNumberTriviaModel.toJson());

      verify(mockSharedPreferences.setString(Constants.GET_CACHED_DATA_TAG, expectedString));
    });
  });
}