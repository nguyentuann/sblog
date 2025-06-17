part of 'categories_bloc.dart';

sealed class CategoriesEvent {}

class GetCategories extends CategoriesEvent {}

class GetCategoryById extends CategoriesEvent {
  final int id;
  GetCategoryById(this.id);
}
