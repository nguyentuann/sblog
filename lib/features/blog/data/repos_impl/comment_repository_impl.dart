import 'package:dartz/dartz.dart';
import 'package:sblog/features/blog/data/sources/api/comment_api.dart';
import 'package:sblog/features/blog/domain/entities/comment.dart';
import 'package:sblog/features/blog/domain/repositories/comment_repository.dart';
import 'package:sblog/service_locator.dart';

class CommentRepositoryImpl implements CommentRepository {
  final commentAPI = sl<CommentAPI>();

// thêm comment
  @override
  Future<Either<String, String>> addComment({
    required String postId,
    required String content,
  }) async {
    try {
      final result = await commentAPI.addComment(postId, content);

      return result.fold(
        (failure) => Left(failure), // Xử lý lỗi
        (success) => Right(''),
      );
    } catch (e) {
      return Left("Lỗi khi thêm bình luận: ${e.toString()}");
    }
  }

// xóa comment
  @override
  Future<Either<String, String>> deleteComment(
      {required String commentId}) async {
    try {
      final result = await commentAPI.deleteComment(commentId);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left("Lỗi khi xóa bình luận: ${e.toString()}");
    }
  }

// lấy comments
  @override
  Future<Either<String, List<Comment>>> getComments(
      {required String postId}) async {
    try {
      final result = await commentAPI.getComments(postId);
      return result.fold(
        (l) => Left(l),
        (comments) => Right(comments.map((e) => e.toEntity()).toList()),
      );
    } catch (e) {
      return Left("Lỗi khi lấy bình luận: ${e.toString()}");
    }
  }

// like comment
  @override
  Future<Either<String, String>> likeComment({required int commentId}) async {
    try {
      final result = await commentAPI.likeComment(commentId);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left("Lỗi khi thích bình luận: ${e.toString()}");
    }
  }

// reply comment
  @override
  Future<Either<String, String>> replyComment({
    required int parentCommentId,
    required String content,
    required String postId,
  }) async {
    try {
      final result =
          await commentAPI.replyComment(parentCommentId, content, postId);
      return result.fold(
        (failure) => Left(failure), // Xử lý lỗi
        (success) => Right(success),
      );
    } catch (e) {
      return Left("Lỗi khi trả lời bình luận: ${e.toString()}");
    }
  }

// cập nhật comment
  @override
  Future<Either<String, String>> updateComment({
    required String commentId,
    required String content,
  }) async {
    try {
      final result = await commentAPI.updateComment(commentId, content);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(''),
      );
    } catch (e) {
      return Left("Lỗi khi cập nhật bình luận: ${e.toString()}");
    }
  }
}
