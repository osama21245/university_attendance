import 'package:block_traning/core/erorr/exception.dart';
import 'package:block_traning/core/erorr/faliure.dart';
import 'package:block_traning/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:block_traning/core/common/entities/user.dart';
import 'package:block_traning/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl(this.authRemoteDataSource);
  @override
  Future<Either<Faliure, User>> loginInWithEmailAndPassword(
      {required String email, required String password}) async {
    return _getUser(() async => await authRemoteDataSource
        .logInWithEmailAndPassword(email: email, password: password));
  }

  @override
  Future<Either<Faliure, User>> signInWithEmailAndPassword(
      {required String email,
      required String password,
      required String name}) async {
    return _getUser(
      () async => await authRemoteDataSource.signUpWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Faliure, User>> _getUser(Future<User> Function() fn) async {
    try {
      final user = await fn();
      print("${user.email}");
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Faliure(e.message));
    } on ServerException catch (e) {
      return left(Faliure(e.message.toString()));
    }
  }

  @override
  Future<Either<Faliure, User?>> getCurrentUserData() async {
    try {
      final user = await authRemoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Faliure('User not logged in!'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Faliure(e.message.toString()));
    }
  }
}
