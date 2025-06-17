import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sblog/features/blog/domain/entities/post.dart';
import 'package:sblog/features/blog/domain/usecases/search_usecase.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchUsecase searchUsecase;
  SearchBloc(this.searchUsecase) : super(SearchInitial()) {
    on<SearchStart>(_onSearchStart);
  }

  _onSearchStart(SearchEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      if (event is SearchStart) {
        final result = await searchUsecase.call(event.keyword);
        result.fold(
          (l) => emit(SearchFailure(l)),
          (r) => emit(SearchSuccess(r)),
        );
      }
    } catch (e) {
      emit(SearchFailure(e.toString()));
    }
  }
}
