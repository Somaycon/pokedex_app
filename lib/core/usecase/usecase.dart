import 'package:fpdart/fpdart.dart';
import 'package:pokedex_app/core/error/failure.dart';

abstract class UseCase<Output, Input> {
  Future<Either<Failure, Output>> call(Input params);
}

class NoParams {}
