import 'package:dartz/dartz.dart';
import 'package:sblog/features/blog/domain/entities/post.dart';

abstract class SearchRepository {
  Future<Either<String, List<Post>>> search(String keyword);
}