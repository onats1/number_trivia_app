import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable {
  Failures([List properties = const <dynamic>[]]) : super([properties]);
}

//General Failures
class ServerFailure extends Failures{}

class CacheFailure extends Failures{}