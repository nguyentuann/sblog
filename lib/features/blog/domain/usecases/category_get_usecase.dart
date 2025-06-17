import 'package:dartz/dartz.dart';
import 'package:sblog/features/blog/domain/repositories/category_repository.dart';
import 'package:sblog/service_locator.dart';

class CategoryGetUsecase {

  final repository = sl<CategoryRepository>();

  Future<Either> call(int? id) async {
    if (id != null) {
      return await repository.getCategoryById(id);
    }

    return await repository.getCategories();
  }
}
