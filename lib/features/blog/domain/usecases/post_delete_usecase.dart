import 'package:sblog/features/blog/domain/repositories/post_repository.dart';
import 'package:sblog/service_locator.dart';

class PostDeleteUsecase {
  final repository = sl<PostRepository>();

  Future<void> call(String postId) async {
    return await repository.deletePost(postId);
  }
}
