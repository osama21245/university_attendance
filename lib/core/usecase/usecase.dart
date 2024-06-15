import 'package:block_traning/core/erorr/faliure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UseCase<SuccessState, Params> {
  Future<Either<Faliure, SuccessState>> call(Params params);
}

class NoParams {}
