import 'package:dartz/dartz.dart';
import 'package:sblog/features/blog/domain/repositories/post_repository.dart';
import 'package:sblog/service_locator.dart';

class PostUpdateUsecase {
  final repository = sl<PostRepository>();

  Future<Either<String, String>> call(
    int id, {
    required String title,
    required String subTitle,
    required String content,
    required String image,
    required int categoryId,
  }) async {
    return await repository.updatePost(
        id, title, subTitle, content, image, categoryId);
  }
}
