import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sblog/features/blog/domain/entities/post.dart';
import 'package:sblog/features/blog/domain/usecases/post_like_usecase.dart';
import 'package:sblog/features/blog/domain/usecases/posts_get_usecase.dart';
import 'package:sblog/service_locator.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super((PostInitial())) {
    on<PostGetStarted>(_onPostGetStarted);
    on<LikePost>(_onLikePost);
  }

  final postGetUsecase = sl<PostsGetUsecase>();
  final postLikeUsecase = sl<PostLikeUsecase>();

  void _onPostGetStarted(
      PostGetStarted event, Emitter<PostState> emit) async {
    try {
      final currentState = state;
      List<Post> oldPosts = [];

      // Nếu là phân trang và đã có dữ liệu trước đó thì giữ lại
      if (event.page > 1 &&
          currentState is PostGetSuccess &&
          currentState.posts.isNotEmpty) {
        oldPosts = currentState.posts;
      } else if (event.page == 1) {
        emit(PostGetInProcess()); // Trang đầu tiên thì loading
      }

      final result = await postGetUsecase.call(
        {
          "page": event.page,
          "limit": event.limit,
          if (event.categoryId != null) "categoryId": event.categoryId,
          if (event.authorId != null) "authorId": event.authorId,
          if (event.liked) "liked": event.liked,
        },
      );

      result.fold(
        (failure) {
          if (oldPosts.isNotEmpty) {
            // Nếu có dữ liệu cũ thì giữ lại
            emit(PostGetSuccess(oldPosts, hasReachedEnd: true));
          } else {
            emit(PostGetFailure(
                "Không thể tải bài viết, vui lòng thử lại sau."));
          }
        },
        (newPosts) {
          final allPosts = [...oldPosts, ...newPosts];
          final hasReachedEnd = newPosts.length < event.limit!;

          emit(PostGetSuccess(allPosts, hasReachedEnd: hasReachedEnd));
        },
      );
    } catch (e) {
      emit(PostGetFailure("Đã xảy ra lỗi: ${e.toString()}"));
    }
  }

  void _onLikePost(LikePost event, Emitter<PostState> emit) async {
    final result = await postLikeUsecase.call(event.postId);
    result.fold((r) {
      log("Thích bài viết thành công");
    }, (l) {});
  }
}
