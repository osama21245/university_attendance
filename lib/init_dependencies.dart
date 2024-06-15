import 'package:block_traning/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:block_traning/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:block_traning/features/auth/data/repositories/auth_repository_ipl.dart';
import 'package:block_traning/features/auth/domain/repository/auth_repository.dart';
import 'package:block_traning/features/auth/domain/usecases/current_user.dart';
import 'package:block_traning/features/auth/domain/usecases/user_sign_in.dart';
import 'package:block_traning/features/auth/domain/usecases/user_sign_up.dart';
import 'package:block_traning/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/secrets/app_secrets.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  var supabase = await Supabase.initialize(
      anonKey: AppSecrets.supabaseApiKey, url: AppSecrets.SupabaseUrl);

  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator()));

  serviceLocator.registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator()));

  serviceLocator.registerFactory(() => UserSignUp(serviceLocator()));
  serviceLocator.registerFactory(() => UserSignIn(serviceLocator()));
  serviceLocator.registerFactory(() => GetCurrentUser(serviceLocator()));

  serviceLocator.registerLazySingleton(() => AuthBloc(
      userSignUp: serviceLocator(),
      userSignIn: serviceLocator(),
      getCurrentUser: serviceLocator(),
      appUserCubit: serviceLocator()));
}
