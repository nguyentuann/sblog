import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sblog/configs/routes/route.dart';
import 'package:sblog/configs/theme/app_theme.dart';
import 'package:sblog/core/state/bloc_state.dart';
import 'package:sblog/core/util/api_helper.dart';
import 'package:sblog/features/auth/data/repos_impl/auth_repository_impl.dart';
import 'package:sblog/features/auth/domain/repositories/auth_repository.dart';
import 'package:sblog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sblog/features/blog/data/repos_impl/category_repository_impl.dart';
import 'package:sblog/features/blog/data/repos_impl/comment_repository_impl.dart';
import 'package:sblog/features/blog/data/repos_impl/post_repository_impl.dart';
import 'package:sblog/features/blog/data/repos_impl/search_repository_impl.dart';
import 'package:sblog/features/blog/domain/repositories/category_repository.dart';
import 'package:sblog/features/blog/domain/repositories/comment_repository.dart';
import 'package:sblog/features/blog/domain/repositories/post_repository.dart';
import 'package:sblog/features/blog/domain/repositories/search_repository.dart';
import 'package:sblog/features/blog/domain/usecases/search_usecase.dart';
import 'package:sblog/features/blog/presentation/bloc/post_create/post_create_bloc.dart';
import 'package:sblog/features/blog/presentation/bloc/search/search_bloc.dart';
import 'package:sblog/features/profile/data/repos_impl/profile_repository_impl.dart';
import 'package:sblog/features/profile/domain/repositories/profile_repository.dart';
import 'package:sblog/features/profile/domain/usecases/profile_usecase.dart';
import 'package:sblog/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:sblog/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeServiceLocator();
  debugPrint = (String? message, {int? wrapWidth}) {};
  await ApiHelper.init();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });
  //
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(),
        ),
        RepositoryProvider<PostRepository>(
          create: (context) => PostRepositoryImpl(),
        ),
        RepositoryProvider<CommentRepository>(
          create: (context) => CommentRepositoryImpl(),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (context) => ProfileRepositoryImpl(),
        ),
        RepositoryProvider<CategoryRepository>(
          create: (context) => CategoryRepositoryImpl(),
        ),
        RepositoryProvider<SearchRepository>(
          create: (context) => SearchRepositoryImpl(),
        ),
      ],
      // Cung cấp repository
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(),
          ),
          BlocProvider(
            create: (context) => PostCreateBloc(),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(
              ProfileUsecase(),
            ),
          ),
          BlocProvider(
            create: (context) => SearchBloc(
              SearchUsecase(),
            ),
          ),
        ],
        child: const AppContent(),
      ),
    );
  }
}

class AppContent extends StatefulWidget {
  const AppContent({
    super.key,
  });

  @override
  State<AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthAuthenticateStarted());
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    log('Auth state: $authState');
    if (authState is InitialState) {
      return Container();
    }
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
