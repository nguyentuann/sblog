import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sblog/features/blog/domain/entities/comment.dart';
import 'package:sblog/features/blog/domain/usecases/comment_usecase.dart';
import 'package:sblog/service_locator.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final commentUsecase = sl<CommentUsecase>();
  CommentBloc() : super(CommentInitial()) {
    on<GetComments>(_onGetComments);
    on<AddComment>(_onAddComment);
    on<UpdateComment>(_onUpdateComment);
    on<DeleteComment>(_onDeleteComment);
    on<ReplyComment>(_onReplyComment);
    on<LikeComment>(_onLikeComment);
  }

  /// Xử lý kết quả chung
  void _handleResult<E>(
    Either<String, E> result,
    Emitter<CommentState> emit,
    Function(E) onSuccess,
  ) {
    result.fold((failure) {
      emit(CommentFailure(failure));
    }, (data) => onSuccess(data));
  }

  /// Lấy danh sách bình luận
  Future<void> _onGetComments(
    GetComments event,
    Emitter<CommentState> emit,
  ) async {
    emit(CommentLoading());
    final result = await commentUsecase.getComments(event.postId);

    _handleResult<List<Comment>>(
      result,
      emit,
      (data) => emit(CommentLoaded(data)),
    );
  }

  /// Thêm bình luận
  Future<void> _onAddComment(
    AddComment event,
    Emitter<CommentState> emit,
  ) async {
    final result = await commentUsecase.addComment(event.postId, event.content);
    _handleResult<String>(result, emit, (data) => emit(CommentSuccess(data)));
  }

  /// Cập nhật bình luận
  Future<void> _onUpdateComment(
    UpdateComment event,
    Emitter<CommentState> emit,
  ) async {
    final result = await commentUsecase.updateComment(
      event.commentId,
      event.content,
    );
    _handleResult<String>(result, emit, (data) => emit(CommentSuccess(data)));
  }

  /// Xóa bình luận
  Future<void> _onDeleteComment(
    DeleteComment event,
    Emitter<CommentState> emit,
  ) async {
    final result = await commentUsecase.deleteComment(event.commentId);
    _handleResult<String>(
      result,
      emit,
      (data) => emit(DeleteCommentSuccess(data)),
    );
  }

  /// Trả lời bình luận
  Future<void> _onReplyComment(
    ReplyComment event,
    Emitter<CommentState> emit,
  ) async {
    final result = await commentUsecase.replyComment(
      event.parentCommentId,
      event.content,
      event.postId,
    );
    _handleResult(result, emit, (data) => emit(CommentSuccess(data)));
  }

  /// Thích bình luận
  Future<void> _onLikeComment(
    LikeComment event,
    Emitter<CommentState> emit,
  ) async {
    final result = await commentUsecase.likeComment(event.commentId);
    _handleResult<String>(
      result,
      emit,
      (data) => (),
    );
  }
}
