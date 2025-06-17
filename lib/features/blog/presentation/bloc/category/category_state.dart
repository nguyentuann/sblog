part of 'category_bloc.dart';


sealed class CategoryState {}

class CategoryInitial extends CategoryState {}



class CategoryLoadedById extends CategoryState {
  final Category category;

  CategoryLoadedById(this.category);
}
class CategoryLoading extends CategoryState {}

class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);
}
