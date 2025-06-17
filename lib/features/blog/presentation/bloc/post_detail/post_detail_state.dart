part of 'post_detail_bloc.dart';

sealed class PostDetailState {}

class PostDetailInitial extends PostDetailState {}

class PostGetByIdedSuccess extends PostDetailState {
  final Post post;

  PostGetByIdedSuccess(this.post);
}

class PostGetByIdFailure extends PostDetailState {
  final String message;

  PostGetByIdFailure(this.message);
}

class PostGetByIdLoading extends PostDetailState {}
