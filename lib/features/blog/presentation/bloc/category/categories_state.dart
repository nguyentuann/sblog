part of 'categories_bloc.dart';

sealed class CategoriesState {}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<Category> categories;

  CategoriesLoaded(this.categories);
}

class CategoryError extends CategoriesState {
  final String message;

  CategoryError(this.message);
}
