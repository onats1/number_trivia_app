import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:numbertriviaapp/core/constants.dart';
import 'package:numbertriviaapp/core/errors/exceptions.dart';
import 'package:numbertriviaapp/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

//Calls the remote endpoint and throws a server exception for all error codes
abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final response = await client.get('${Constants.REMOTE_URL}/$number',
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    final response = await client.get('${Constants.REMOTE_URL}/random',
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200){
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }

  }
}
