part of 'post_bloc.dart';

sealed class PostState extends Equatable {}

class PostInitial extends PostState {
  @override
  List<Object> get props => [];
}

// class lấy post
class PostGetSuccess extends PostState {
  final List<Post> posts;
  final bool hasReachedEnd;

  PostGetSuccess(this.posts, {this.hasReachedEnd = false});

  @override
  List<Object?> get props => [posts, hasReachedEnd];
}

class PostGetInProcess extends PostState {
  @override
  List<Object?> get props => [];
}

class PostGetFailure extends PostState {
  final String message;

  PostGetFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// class like post
class PostLikeSuccess extends PostState {
  @override
  List<Object?> get props => [];
}

class PostLikeFailure extends PostState {
  @override
  List<Object?> get props => [];
}

