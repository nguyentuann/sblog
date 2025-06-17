import 'package:dartz/dartz.dart';
import 'package:sblog/features/blog/domain/entities/post.dart';
import 'package:sblog/features/blog/domain/repositories/search_repository.dart';
import 'package:sblog/service_locator.dart';

class SearchUsecase {
  final repository = sl<SearchRepository>();

  Future<Either<String, List<Post>>> call(String query) async {
    return await repository.search(query);
  }
}
