part of 'category_bloc.dart';

sealed class CategoryEvent {}


class GetCategoryById extends CategoryEvent {
  final int id;
  GetCategoryById(this.id);
}
