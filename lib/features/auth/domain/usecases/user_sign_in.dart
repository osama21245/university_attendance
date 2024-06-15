import 'package:block_traning/core/erorr/faliure.dart';
import 'package:block_traning/core/usecase/usecase.dart';
import 'package:block_traning/features/auth/domain/repository/auth_repository.dart';
// ignore: implementation_imports
import 'package:fpdart/src/either.dart';

import '../../../../core/common/entities/user.dart';

class UserSignIn implements UseCase<User, UserSignInParams> {
  final AuthRepository authRepository;

  UserSignIn(this.authRepository);

  @override
  Future<Either<Faliure, User>> call(UserSignInParams UserSignInParams) async {
    return await authRepository.loginInWithEmailAndPassword(
      email: UserSignInParams.email,
      password: UserSignInParams.password,
    );
  }
}

class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams(
    this.email,
    this.password,
  );
}
