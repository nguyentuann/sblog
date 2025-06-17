part of 'comment_bloc.dart';

abstract class CommentEvent {}

class GetComments extends CommentEvent {
  final String postId;
  GetComments({required this.postId});
}

class AddComment extends CommentEvent {
  final String postId;
  final String content;
  AddComment({required this.postId, required this.content});
}

class UpdateComment extends CommentEvent {
  final String commentId;
  final String content;
  UpdateComment({required this.commentId, required this.content});
}

class DeleteComment extends CommentEvent {
  final String commentId;
  DeleteComment({required this.commentId});
}

class ReplyComment extends CommentEvent {
  final int parentCommentId;
  final String content;
  final String postId;
  ReplyComment({required this.content, required this.parentCommentId, required this.postId});
}

class LikeComment extends CommentEvent {
  final int commentId;
  LikeComment({
    required this.commentId,
  });
}
