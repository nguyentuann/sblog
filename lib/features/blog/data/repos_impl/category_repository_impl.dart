import 'package:dartz/dartz.dart';
import 'package:sblog/features/blog/data/sources/api/category_api.dart';
import 'package:sblog/features/blog/domain/entities/category.dart';
import 'package:sblog/features/blog/domain/repositories/category_repository.dart';
import 'package:sblog/service_locator.dart';

class CategoryRepositoryImpl extends CategoryRepository {
  final categoryApi = sl<CategoryAPI>();
  @override
  Future<Either<String, List<Category>>> getCategories() async {
    try {
      final response = await categoryApi.getAllCategories();
      List<Category> categories = response.map((e) => e.toEntity()).toList();
      return Right(categories);
    } catch (e) {
      return Left("Connection error: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, Category>> getCategoryById(int id) async {
    try {
      final response = await categoryApi.getCategoryById(id);
      final category = response.toEntity();
      return Right(category);
    } catch (e) {
      return Left("Connection error: ${e.toString()}");
    }
  }
}
