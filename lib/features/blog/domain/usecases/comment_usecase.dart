import 'package:dartz/dartz.dart';
import 'package:sblog/features/blog/domain/entities/comment.dart';
import 'package:sblog/features/blog/domain/repositories/comment_repository.dart';
import 'package:sblog/service_locator.dart';

class CommentUsecase {
  final repository = sl<CommentRepository>();

  /// Like hoặc Unlike bình luận
  Future<Either<String, String>> likeComment(int commentId) async {
    return await repository.likeComment(commentId: commentId);
  }

  /// Trả lời bình luận
  Future<Either<String, dynamic>> replyComment(
    int parentCommentId,
    String content,
    String postId,
  ) async {
    return await repository.replyComment(
        parentCommentId: parentCommentId, content: content, postId: postId);
  }

  /// Cập nhật nội dung bình luận
  Future<Either<String, String>> updateComment(
    String commentId,
    String content,
  ) async {
    return await repository.updateComment(
        commentId: commentId, content: content);
  }

  /// Xóa bình luận
  Future<Either<String, String>> deleteComment(String commentId) async {
    return await repository.deleteComment(commentId: commentId);
  }

  /// Thêm bình luận mới vào bài viết
  Future<Either<String, String>> addComment(
    String postId,
    String content,
  ) async {
    return await repository.addComment(
      postId: postId,
      content: content,
    );
  }

  /// Lấy danh sách bình luận của một bài viết
  Future<Either<String, List<Comment>>> getComments(String postId) async {
    return await repository.getComments(postId: postId);
  }
}
