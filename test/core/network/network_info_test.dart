import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:numbertriviaapp/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker{}

void main(){
  NetworkInfoImpl networkInfoImpl;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp((){
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group("Is connected", (){
    test("Should forward the call to DataConnection.hasConnection", () async{

      final networkValue = Future.value(true);
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_)  => networkValue);

      final result = networkInfoImpl.isConnected;

      verify(mockDataConnectionChecker.hasConnection);
      expect(result, networkValue);
    });
  });
}