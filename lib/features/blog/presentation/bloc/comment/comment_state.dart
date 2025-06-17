part of 'comment_bloc.dart';

sealed class CommentState {}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final List<Comment> comments;

  CommentLoaded(this.comments);
}

/// Gom chung tất cả lỗi vào một state
class CommentFailure extends CommentState {
  final String message;

  CommentFailure(this.message);
}

class CommentSuccess extends CommentState {
  final String result;

  CommentSuccess(this.result);
}

class CommentLikeSuccess extends CommentState {
  String message;
  CommentLikeSuccess(this.message);
}

class CommentReplySuccess extends CommentState {
  final Comment newReply;
  CommentReplySuccess(this.newReply);
}

class ReplyLikeSuccess extends CommentState {
  ReplyLikeSuccess();
}

class DeleteCommentSuccess extends CommentState {
  final String message;
  DeleteCommentSuccess(this.message);
}

class DeleteReplySuccess extends CommentState {
  final String message;
  DeleteReplySuccess(this.message);
}
