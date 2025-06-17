import 'package:dartz/dartz.dart';
import 'package:sblog/core/constant/api_endpoints.dart';
import 'package:sblog/core/util/api_helper.dart';
import 'package:sblog/features/blog/data/models/post_model.dart';

class SearchAPI {
  Future<Either<String, List<PostModel>>> search(String keyword) async {
    try {
      final response = await ApiHelper.get(
        ApiEndpoints.search["search"]!,
        params: {"q": keyword, "type": "less"},
      );
      final List<PostModel> posts = [];
      if (response.statusCode == 200) {
        final data = response.data["data"]["posts"];
        for (var post in data) {
          posts.add(PostModel.fromJson(post));
        }
      }
      return Right(posts);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
