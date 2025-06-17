import 'package:dartz/dartz.dart';
import 'package:sblog/features/blog/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<Either<String, List<Category>>> getCategories();
  Future<Either<String, Category>> getCategoryById(int id);
}
