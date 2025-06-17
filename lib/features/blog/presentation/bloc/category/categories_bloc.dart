import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sblog/features/blog/domain/entities/category.dart';
import 'package:sblog/features/blog/domain/usecases/category_get_usecase.dart';
import 'package:sblog/service_locator.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final categoriesUsecase = sl<CategoryGetUsecase>();
  CategoriesBloc() : super(CategoriesInitial()) {
    on<GetCategories>(_onGetCategories);
  }

  _onGetCategories(GetCategories event, Emitter<CategoriesState> emit) async {
    emit(CategoriesLoading());
    try {
      final result = await categoriesUsecase.call(null);
      result.fold(
        (l) => emit(CategoryError(l)),
        (r) => emit(CategoriesLoaded(r)),
      );
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
