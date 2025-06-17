
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sblog/features/blog/domain/entities/category.dart';
import 'package:sblog/features/blog/domain/usecases/category_get_usecase.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryGetUsecase categoryGetUsecase;
  CategoryBloc(this.categoryGetUsecase) : super(CategoryInitial()) {
    on<GetCategoryById>(_onGetCategoryById);
  }


   _onGetCategoryById(GetCategoryById event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final result = await categoryGetUsecase.call(event.id);
      result.fold(
        (l) => emit(CategoryError(l)),
        (r) => emit(CategoryLoadedById(r)),
      );
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
