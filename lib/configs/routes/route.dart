import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sblog/core/state/bloc_state.dart';
import 'package:sblog/features/auth/domain/entities/user.dart';
import 'package:sblog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sblog/features/auth/presentation/page/auth.dart';
import 'package:sblog/features/auth/presentation/page/retrieve_password.dart';
import 'package:sblog/features/blog/domain/entities/post.dart';
import 'package:sblog/features/blog/presentation/page/all_post/post_list.dart';
import 'package:sblog/features/blog/presentation/page/create_post/new_post.dart';
import 'package:sblog/features/blog/presentation/page/home.dart';
import 'package:sblog/features/auth/presentation/page/splash.dart';
import 'package:sblog/features/blog/presentation/page/search/search.dart';
import 'package:sblog/features/blog/presentation/widget/post_widget/post_detail.dart';
import 'package:sblog/features/profile/presentation/page/change_password.dart';
import 'package:sblog/features/profile/presentation/page/edit_profile.dart';
import 'package:sblog/features/profile/presentation/page/profile.dart';

class RouteName {
  static const String home = '/';
  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String postDetail = '/post_detail';
  static const String postList = '/post_list_category';
  static const String postListByIdUser = '/post_list_user_id';
  static const String profile = '/profile';
  static const String create = '/create';
  static const String editPost = '/edit_post';
  static const String search = '/search';
  static const String editProfile = '/edit_profile';
  static const String changePassword = '/change_password';
  static const String retrievePassword = '/retrieve_password';
}

// Cấu hình GoRouter
final router = GoRouter(
  initialLocation: RouteName.splash,
  redirect: (context, state) {
    final authState = BlocProvider.of<AuthBloc>(context, listen: false).state;

    if (authState is InitialState) return null;

    final isAuthRoute = [
      RouteName.auth,
      RouteName.retrievePassword,
      RouteName.postDetail,
      RouteName.create,
      RouteName.postList,
      RouteName.search,
      RouteName.editProfile,
      RouteName.changePassword,
      RouteName.profile,
      RouteName.editPost,
      RouteName.postListByIdUser,
    ].contains(state.fullPath);

    if (authState is FailureState<User>) return RouteName.auth;
    if (!isAuthRoute && (authState is SuccessState<User?>)) {
      return RouteName.home;
    }

    return null;
  },
  routes: [
    GoRoute(path: RouteName.splash, builder: (_, __) => const SplashScreen()),
    GoRoute(path: RouteName.auth, builder: (_, __) => const AuthScreen()),
    GoRoute(
        path: RouteName.retrievePassword,
        builder: (_, __) => const RetrievePassword()),
    GoRoute(path: RouteName.home, builder: (_, __) => const HomeScreen()),
    GoRoute(
      path: RouteName.postDetail,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return PostDetail(
          postId: extra['postId'],
          isEditable: extra['isEditable'],
        );
      },
    ),
    GoRoute(path: RouteName.create, builder: (_, __) => const NewPostScreen()),
    GoRoute(
      path: RouteName.postList,
      builder: (context, state) {
        final categoryId = getExtra<String>(state, 'categoryId');
        return DefaultScaffold(child: PostList(categoryId: categoryId));
      },
    ),
    GoRoute(
      path: RouteName.postListByIdUser,
      builder: (context, state) {
        final userId = getExtra<int>(state, 'userId');
        final isEditable = getExtra<bool>(state, 'isEditable');
        return DefaultScaffold(
          child: PostList(authorId: userId, isEditable: isEditable),
        );
      },
    ),
    GoRoute(path: RouteName.search, builder: (_, __) => const SearchScreen()),
    GoRoute(
      path: RouteName.profile,
      builder: (context, state) => ProfileScreen(userId: state.extra as int?),
    ),
    GoRoute(
      path: RouteName.editProfile,
      builder: (context, state) {
        final user = (state.extra as Map<String, dynamic>)['user'] as User;
        return EditProfile(user: user);
      },
    ),
    GoRoute(
        path: RouteName.changePassword,
        builder: (_, __) => const ChangePasswordScreen()),
    GoRoute(
      path: RouteName.editPost,
      builder: (context, state) => NewPostScreen(post: state.extra as Post),
    ),
  ],
);

T getExtra<T>(GoRouterState state, String key) {
  final extra = state.extra as Map<String, dynamic>;
  return extra[key] as T;
}

class DefaultScaffold extends StatelessWidget {
  final Widget child;
  const DefaultScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: child,
    );
  }
}
