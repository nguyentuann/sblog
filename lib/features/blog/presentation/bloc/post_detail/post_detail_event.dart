part of 'post_detail_bloc.dart';

abstract class PostDetailEvent {}

class PostGetById extends PostDetailEvent {
  final String postId;
  PostGetById({required this.postId});
}

class DeletePost extends PostDetailEvent {
  final String postId;
  DeletePost({required this.postId});
}
