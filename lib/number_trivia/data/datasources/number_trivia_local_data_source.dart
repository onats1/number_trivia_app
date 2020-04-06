import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:numbertriviaapp/core/constants.dart';
import 'package:numbertriviaapp/core/errors/exceptions.dart';
import 'package:numbertriviaapp/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {

    final result = sharedPreferences.getString(Constants.GET_CACHED_DATA_TAG);
    if (result != null){
      return Future.value(NumberTriviaModel.fromJson(json.decode(result)));
    } else {
      throw CacheException();
    }

  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    sharedPreferences.setString(Constants.GET_CACHED_DATA_TAG, json.encode(triviaToCache.toJson()));
    return Future.value(null);
  }

}
