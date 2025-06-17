import 'package:get_it/get_it.dart';
import 'package:sblog/core/util/local_data.dart';
import 'package:sblog/features/auth/data/repos_impl/auth_repository_impl.dart';
import 'package:sblog/features/auth/data/sources/api/auth_api.dart';
import 'package:sblog/features/auth/domain/repositories/auth_repository.dart';
import 'package:sblog/features/auth/domain/usecases/authenticate_usecase.dart';
import 'package:sblog/features/auth/domain/usecases/login_usecase.dart';
import 'package:sblog/features/auth/domain/usecases/logout_usecase.dart';
import 'package:sblog/features/auth/domain/usecases/register_usecase.dart';
import 'package:sblog/features/blog/data/repos_impl/category_repository_impl.dart';
import 'package:sblog/features/blog/data/repos_impl/comment_repository_impl.dart';
import 'package:sblog/features/blog/data/repos_impl/post_repository_impl.dart';
import 'package:sblog/features/blog/data/repos_impl/search_repository_impl.dart';
import 'package:sblog/features/blog/data/sources/api/category_api.dart';
import 'package:sblog/features/blog/data/sources/api/comment_api.dart';
import 'package:sblog/features/blog/data/sources/api/post_api.dart';
import 'package:sblog/features/blog/data/sources/api/search_api.dart';
import 'package:sblog/features/blog/domain/repositories/category_repository.dart';
import 'package:sblog/features/blog/domain/repositories/comment_repository.dart';
import 'package:sblog/features/blog/domain/repositories/post_repository.dart';
import 'package:sblog/features/blog/domain/repositories/search_repository.dart';
import 'package:sblog/features/blog/domain/usecases/category_get_usecase.dart';
import 'package:sblog/features/blog/domain/usecases/comment_usecase.dart';
import 'package:sblog/features/blog/domain/usecases/post_create_usecase.dart';
import 'package:sblog/features/blog/domain/usecases/post_delete_usecase.dart';
import 'package:sblog/features/blog/domain/usecases/post_like_usecase.dart';
import 'package:sblog/features/blog/domain/usecases/post_update_usecase.dart';
import 'package:sblog/features/blog/domain/usecases/posts_get_usecase.dart';
import 'package:sblog/features/blog/domain/usecases/search_usecase.dart';
import 'package:sblog/features/profile/data/repos_impl/profile_repository_impl.dart';
import 'package:sblog/features/profile/data/sources/profile_api.dart';
import 'package:sblog/features/profile/domain/repositories/profile_repository.dart';
import 'package:sblog/features/profile/domain/usecases/profile_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initializeServiceLocator() async {
  final prefs = await SharedPreferences.getInstance();

  // CORE
  sl.registerSingleton<SharedPreferences>(prefs);
  sl.registerSingleton<LocalData>(LocalData());

  // AUTH
  _initAuthModule();

  // BLOG / POST
  _initBlogModule();

  // USER PROFILE
  _initUserProfile();


}

void _initAuthModule() {
  // API
  sl.registerSingleton<AuthAPI>(AuthAPI());

  // Repository
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());

  // UseCases
  sl.registerSingleton<LoginUseCase>(LoginUseCase());
  sl.registerSingleton<RegisterUsecase>(RegisterUsecase());
  sl.registerSingleton<AuthenticateUsecase>(AuthenticateUsecase());
  sl.registerSingleton<LogoutUsecase>(LogoutUsecase());
}

void _initBlogModule() {
  // API
  sl.registerSingleton<PostAPI>(PostAPI());
  sl.registerSingleton<CategoryAPI>(CategoryAPI());
  sl.registerSingleton<CommentAPI>(CommentAPI());
  sl.registerSingleton<SearchAPI>(SearchAPI());

  // Repository
  sl.registerSingleton<PostRepository>(PostRepositoryImpl());
  sl.registerSingleton<CategoryRepository>(CategoryRepositoryImpl());
  sl.registerSingleton<SearchRepository>(SearchRepositoryImpl());
  sl.registerSingleton<CommentRepository>(CommentRepositoryImpl());

  // UseCases
  sl.registerSingleton<CategoryGetUsecase>(CategoryGetUsecase());
  sl.registerSingleton<CommentUsecase>(CommentUsecase());
  sl.registerSingleton<PostCreateUsecase>(PostCreateUsecase());
  sl.registerSingleton<PostLikeUsecase>(PostLikeUsecase());
  sl.registerSingleton<PostDeleteUsecase>(PostDeleteUsecase());
  sl.registerSingleton<PostUpdateUsecase>(PostUpdateUsecase());
  sl.registerSingleton<PostsGetUsecase>(PostsGetUsecase());
  sl.registerSingleton<SearchUsecase>(SearchUsecase());
}

void _initUserProfile() {
  // API
  sl.registerSingleton<ProfileAPI>(ProfileAPI());

  // Repository
  sl.registerSingleton<ProfileRepository>(ProfileRepositoryImpl());
  // UseCases
  sl.registerSingleton<ProfileUsecase>(ProfileUsecase());
}
