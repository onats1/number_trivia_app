

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:numbertriviaapp/core/network/network_info.dart';
import 'package:numbertriviaapp/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:numbertriviaapp/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:numbertriviaapp/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:numbertriviaapp/number_trivia/domain/repositories/num_trivia_repo.dart';
import 'package:numbertriviaapp/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numbertriviaapp/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {

  sl.registerFactory(() => NumberTriviaBloc(
    concrete: sl(),
    random:  sl(),
    input: sl()
  ));

  sl.registerLazySingleton(() => GetRandomNumberTrivia(
    sl()
  ));
  
  sl.registerLazySingleton<NumberTriviaRepository>(() => NumberTriviaRepositoryImpl(
    numberTriviaLocalDataSource: sl(),
    numberTriviaRemoteDataSource: sl(),
    networkInfo: sl()
  ));
  
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(() => NumberTriviaRemoteDataSourceImpl(
    client: sl()
  ));
  
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(() => NumberTriviaLocalDataSourceImpl(
    sharedPreferences: sl()
  ));

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(
    sl()
  ));

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DataConnectionChecker());

}