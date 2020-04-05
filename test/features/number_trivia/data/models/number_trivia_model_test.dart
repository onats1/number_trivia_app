import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:numbertriviaapp/number_trivia/data/models/number_trivia_model.dart';
import 'package:numbertriviaapp/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final numberTriviaModel = NumberTriviaModel(number: 1, text: "Test");

  test("Test that NumberTriviaModel extends Number trivia", () async {
    expect(numberTriviaModel, isA<NumberTrivia>());
  });

  group("from json", () {
    test(
        'Should return a valid model when the JSON number is a string', () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, numberTriviaModel);
    });

    test(
        'Should return a valid model when the JSON number is regarded as a double', () async {
      final Map<String, dynamic> jsonMap = json.decode(
          fixture('trivia_double.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, numberTriviaModel);
    });
  });

  group("to json", () {
    test('Should return a valid json object from the model', () async {
      final jsonObject = {
        "text": "Test",
        "number": 1
      };

      final result = numberTriviaModel.toJson();

      expect(result, jsonObject);
    });

  });
}
