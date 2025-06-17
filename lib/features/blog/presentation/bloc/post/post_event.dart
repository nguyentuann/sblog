part of 'post_bloc.dart';

abstract class PostEvent {}

// Lấy bài viết (tổng quát cho tất cả các loại)
class PostGetStarted extends PostEvent {
  final int page;
  final int? limit;
  final int? authorId;
  final String? categoryId;
  final bool liked;

  PostGetStarted({
    required this.page,
    this.limit=10,
    this.authorId,
    this.categoryId,
    this.liked = false,
  });
}

// Like post
class LikePost extends PostEvent {
  final int postId;
  LikePost({required this.postId});
}

