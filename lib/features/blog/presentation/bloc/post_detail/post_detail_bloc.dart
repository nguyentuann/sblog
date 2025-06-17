import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sblog/features/blog/domain/entities/post.dart';
import 'package:sblog/features/blog/domain/usecases/post_delete_usecase.dart';
import 'package:sblog/features/blog/domain/usecases/posts_get_usecase.dart';
import 'package:sblog/service_locator.dart';

part 'post_detail_event.dart';
part 'post_detail_state.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  PostDetailBloc() : super(PostDetailInitial()) {
    on<PostGetById>(_onPostGetById);
    on<DeletePost>(_onDeletePost);
  }

  final postGetUsecase = sl<PostsGetUsecase>();
  final postDeleteUsecase = sl<PostDeleteUsecase>();

  void _onPostGetById(PostGetById event, Emitter<PostDetailState> emit) async {
    emit(PostGetByIdLoading());
    final result = await postGetUsecase.call(event.postId);
    result.fold(
      (l) => emit(PostGetByIdFailure(l.toString())),
      (r) => emit(PostGetByIdedSuccess(r[0])),
    );
  }

  void _onDeletePost(DeletePost event, Emitter<PostDetailState> emit) async {
    emit(PostGetByIdLoading());
    await postDeleteUsecase.call(event.postId);
  }
}
