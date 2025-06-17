import 'package:dartz/dartz.dart';
import 'package:sblog/features/blog/domain/repositories/post_repository.dart';
import 'package:sblog/service_locator.dart';

class PostLikeUsecase {
  final repository = sl<PostRepository>();

  Future<Either<String, String>> call(int postId) async {
    return await repository.likePost(postId);
  }
}
