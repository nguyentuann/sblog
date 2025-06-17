part of 'search_bloc.dart';

sealed class SearchState {}

class SearchInitial extends SearchState {}

class SearchSuccess extends SearchState {
  final List<Post> posts;

  SearchSuccess(this.posts);
}

class SearchLoading extends SearchState {
  SearchLoading();
}

class SearchFailure extends SearchState {
  final String message;

  SearchFailure(this.message);
}
