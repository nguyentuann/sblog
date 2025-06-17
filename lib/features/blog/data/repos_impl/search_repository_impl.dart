import 'package:dartz/dartz.dart';
import 'package:sblog/features/blog/data/sources/api/search_api.dart';
import 'package:sblog/features/blog/domain/entities/post.dart';
import 'package:sblog/features/blog/domain/repositories/search_repository.dart';
import 'package:sblog/service_locator.dart';

class SearchRepositoryImpl extends SearchRepository {
  final searchApi = sl<SearchAPI>();
  @override
  Future<Either<String, List<Post>>> search(String keyword) async {
    try {
      final response = await searchApi.search(keyword);
      return response.fold(
        (l) => Left(l),
        (r) {
          final posts = r.map((e) => e.toEntity()).toList();
          return Right(posts);
        },
      );
    } catch (e) {
      return Left("Connection error: ${e.toString()}");
    }
  }
}
