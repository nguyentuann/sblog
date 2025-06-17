import 'package:dartz/dartz.dart';
import 'package:sblog/features/blog/domain/entities/post.dart';
import 'package:sblog/features/blog/domain/repositories/post_repository.dart';
import 'package:sblog/service_locator.dart';

class PostsGetUsecase {
  final repository = sl<PostRepository>();

  Future<Either<String, List<Post>>> call(params) async {
    if (params is String) {
      return await repository.getPostById(params, null);
    }
    if (params is Map<String, dynamic>) {
      if (params.containsKey("categoryId")) {
        return await repository.getPostsByCategory(
            params["categoryId"], params);
      } else if (params.containsKey("liked")) {
        return await repository.getPosts(params);
      } else if (params.containsKey("authorId")) {
        final newParams = Map<String, dynamic>.from(params);
        newParams.remove("authorId");
        newParams["author"] = params["authorId"];
        return await repository.getPosts(newParams);
      } else {
        return await repository.getPosts(params);
      }
    }
    return Left("Tham số không hợp lệ");
  }
}
