import 'package:dartz/dartz.dart';
import 'package:sblog/features/blog/domain/entities/comment.dart';

abstract class CommentRepository {
  /// Thêm bình luận vào bài viết
  Future<Either<String, String>> addComment({
    required String postId, 
    required String content, // Đổi 'comment' thành 'content' để đồng bộ với replyComment
  });

  /// Xóa một bình luận
  Future<Either<String, String>> deleteComment({
    required String commentId,
  });

  /// Cập nhật nội dung bình luận
  Future<Either<String, String>> updateComment({
    required String commentId, 
    required String content, 
  });

  /// Lấy danh sách bình luận của một bài viết
  Future<Either<String, List<Comment>>> getComments({
    required String postId,
  });

  /// Thích/Bỏ thích bình luận
  Future<Either<String, String>> likeComment({
    required int commentId,
  });

  /// Trả lời bình luận
  Future<Either<String, String>> replyComment({
    required int parentCommentId,
    required String content,
    required String postId,
  });
}
