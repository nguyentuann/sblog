import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:sblog/core/constant/api_endpoints.dart';
import 'package:sblog/core/util/api_helper.dart';
import 'package:sblog/features/blog/data/models/comment_model.dart';

class CommentAPI {
  Future<Either<String, List<CommentModel>>> _fetchComments(
      String endpoint) async {
    try {
      final response = await ApiHelper.get(endpoint);
      if (response.statusCode == 200) {
        final data = response.data["data"];
        try {
          return Right((data as List)
              .map(
                  (json) => CommentModel.fromJson(json as Map<String, dynamic>))
              .toList());
        } catch (e) {
          log("Error parsing comments: $e");
          return const Right([]);
        }
      } else {
        return Left("Lỗi từ server: ${response.statusCode}");
      }
    } catch (e) {
      return Left("Lỗi khi tải bình luận: ${e.toString()}");
    }
  }

  Future<Either<String, List<CommentModel>>> getComments(String postId) =>
      _fetchComments(ApiEndpoints.getCommentById(postId));

  Future<Either<String, String>> addComment(
      String postId, String content) async {
    try {
      final response = await ApiHelper.post(ApiEndpoints.comments["create"]!, {
        'content': content,
        'post': postId,
      });
      if (response.statusCode == 201) {
        return Right('');
      } else {
        return const Left('Thêm bình luận thất bại!');
      }
    } catch (e) {
      return Left("Lỗi khi thêm bình luận: ${e.toString()}");
    }
  }

  Future<Either<String, CommentModel>> updateComment(
      String commentId, String newContent) async {
    try {
      final response = await ApiHelper.put(
        '/posts/comments/$commentId',
        {
          'content': newContent,
          'comment': commentId,
        },
      );
      if (response.statusCode == 200) {
        return Right(CommentModel.fromJson(response.data));
      } else {
        return Left(
            "Lỗi khi cập nhật bình luận: ${response.data['message'] ?? 'Không xác định'}");
      }
    } catch (e) {
      return Left("Lỗi khi cập nhật bình luận: ${e.toString()}");
    }
  }

  Future<Either<String, String>> deleteComment(String commentId) async {
    try {
      final response = await ApiHelper.delete('/posts/comments/$commentId');
      if (response.statusCode == 200) {
        return const Right("Xóa bình luận thành công!");
      } else {
        return Left(
            "Lỗi khi xóa bình luận: ${response.data['message'] ?? 'Không xác định'}");
      }
    } catch (e) {
      return Left("Lỗi khi xóa bình luận: ${e.toString()}");
    }
  }

  Future<Either<String, String>> likeComment(int commentId) async {
    try {
      final response = await ApiHelper.post(
          ApiEndpoints.likeComment(commentId.toString()), {});
      if (response.statusCode == 200) {
        log("like comment: ${response.data}");
        return const Right("Thích bình luận thành công");
      } else {
        return Left(
            "Lỗi khi thích bình luận: ${response.data['message'] ?? 'Không xác định'}");
      }
    } catch (e) {
      return Left("Lỗi khi thích bình luận: ${e.toString()}");
    }
  }

  Future<Either<String, String>> replyComment(
      int commentId, String content, String postId) async {
    try {
      final urlWithQuery =
          "${ApiEndpoints.comments['reply']}?parent=$commentId";
      final response = await ApiHelper.post(
          urlWithQuery, {'content': content, 'post': postId});
      if (response.statusCode == 201) {
        return const Right("Trả lời bình luận thành công");
      } else {
        return Left(
            "Lỗi khi trả lời bình luận: ${response.data['message'] ?? 'Không xác định'}");
      }
    } catch (e) {
      return Left("Lỗi khi trả lời bình luận: ${e.toString()}");
    }
  }
}
