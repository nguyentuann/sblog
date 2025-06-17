part of 'post_create_bloc.dart';

sealed class PostCreateState {}

final class PostCreateInitial extends PostCreateState {}

class PostCreateStarted extends PostCreateState {}

class PostCreateInProcess extends PostCreateState {}

class PostCreateSuccess extends PostCreateState {
  final String message;
  PostCreateSuccess(this.message);
}

class PostCreateFailure extends PostCreateState {
  final String message;

  PostCreateFailure(this.message);
}

class PostEditStarted extends PostCreateState {}

class PostEditInProcess extends PostCreateState {}

class PostEditSuccess extends PostCreateState {
  final Post post;

  PostEditSuccess(this.post);
}

class PostEditFailure extends PostCreateState {
  final String message;

  PostEditFailure(this.message);
}

class UploadImageSuccess extends PostCreateState {
  final String url;
  UploadImageSuccess(this.url);
}

class UploadImageInProcess extends PostCreateState {}

class UploadImageFailure extends PostCreateState {
  final String message;

  UploadImageFailure(this.message);
}