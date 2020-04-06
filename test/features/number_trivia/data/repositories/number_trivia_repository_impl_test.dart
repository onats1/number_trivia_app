import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numbertriviaapp/core/errors/exceptions.dart';
import 'package:numbertriviaapp/core/errors/failures.dart';
import 'package:numbertriviaapp/core/network/network_info.dart';
import 'package:numbertriviaapp/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:numbertriviaapp/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:numbertriviaapp/number_trivia/data/models/number_trivia_model.dart';
import 'package:numbertriviaapp/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:numbertriviaapp/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repositoryImpl;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = NumberTriviaRepositoryImpl(
        numberTriviaRemoteDataSource: mockRemoteDataSource,
        numberTriviaLocalDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestsOnline(Function body) {
    group("device online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group("device offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group("get Concrete number trivia", () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: "test trivia");
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test("Should check if the device is online", () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      repositoryImpl.getConcreteNumberTrivia(1);
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          "Should return remote data when the call to the remote data source is successful",
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          "Should cache data locally when the call to the remote data source is successful",
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        await repositoryImpl.getConcreteNumberTrivia(tNumber);
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          "Should return server failure when the call to the remote data source is unsuccessful",
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());

        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test("Should return last locally cached data when the cache is present",
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });

      test("Should return cache failure when there is no cache present",
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group("get Random number trivia", () {

    final tNumber = 1;
    final tNumberTriviaModel =
    NumberTriviaModel(number: tNumber, text: "test trivia");
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test("Should check if the device is online", () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      repositoryImpl.getRandomNumberTrivia();
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          "Should return remote data when the call to the remote data source is successful",
              () async {
            when(mockRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);

            final result = await repositoryImpl.getRandomNumberTrivia();
            verify(mockRemoteDataSource.getRandomNumberTrivia());
            expect(result, equals(Right(tNumberTrivia)));
          });

      test(
          "Should cache data locally when the call to the remote data source is successful",
              () async {
            when(mockRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);

            await repositoryImpl.getRandomNumberTrivia();
            verify(mockRemoteDataSource.getRandomNumberTrivia());
            verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
          });

      test(
          "Should return server failure when the call to the remote data source is unsuccessful",
              () async {
            when(mockRemoteDataSource.getRandomNumberTrivia())
                .thenThrow(ServerException());

            final result = await repositoryImpl.getRandomNumberTrivia();
            verify(mockRemoteDataSource.getRandomNumberTrivia());
            verifyZeroInteractions(mockLocalDataSource);
            expect(result, Left(ServerFailure()));
          });
    });

    runTestsOffline(() {
      test("Should return last locally cached data when the cache is present",
              () async {
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);

            final result = await repositoryImpl.getRandomNumberTrivia();
            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(result, Right(tNumberTrivia));
          });

      test("Should return cache failure when there is no cache present",
              () async {
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());

            final result = await repositoryImpl.getRandomNumberTrivia();

            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Left(CacheFailure())));
          });
    });
  });
}
