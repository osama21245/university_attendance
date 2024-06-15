import 'package:block_traning/core/erorr/exception.dart';
import 'package:block_traning/features/auth/data/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailAndPassword(
      {required String name, required String email, required String password});

  Future<UserModel> logInWithEmailAndPassword(
      {required String email, required String password});

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  AuthRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<UserModel> logInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final response = await supabaseClient.auth
          .signInWithPassword(email: email, password: password);
      if (response.user == null) {
        throw ServerException("Email or Passowrd is wrong");
      } else {
        return UserModel.fromJson(response.user!.toJson())
            .copyWith(email: currentUserSession!.user.email);
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          'name': name,
        },
      );
      if (response.user == null) {
        throw ServerException("User is null");
      }
      return UserModel.fromJson(response.user!.toJson())
          .copyWith(email: currentUserSession!.user.email);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userdata = await supabaseClient
            .from("profiles")
            .select()
            .eq("id", currentUserSession!.user.id);

        return UserModel.fromJson(userdata.first)
            .copyWith(email: currentUserSession!.user.email);
      }
      return null;
    } on ServerException catch (e) {
      throw ServerException(e.toString());
    }
  }
}
