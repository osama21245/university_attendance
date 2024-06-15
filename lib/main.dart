import 'package:block_traning/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:block_traning/core/theme/theme_data.dart';
import 'package:block_traning/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:block_traning/features/auth/presentation/pages/login_page.dart';
import 'package:block_traning/features/blog/presentation/pages/add_new_blog_screen.dart';
import 'package:block_traning/home_screen.dart';
import 'package:block_traning/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
      BlocProvider(create: (_) => serviceLocator<AppUserCubit>())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.appDarkTheme,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserIsLogIn;
        },
        builder: (context, isLogIn) {
          if (isLogIn) {
            return const HomeScreen();
          } else {
            return const AddNewBlogScreen();
          }
        },
      ),
    );
  }
}
