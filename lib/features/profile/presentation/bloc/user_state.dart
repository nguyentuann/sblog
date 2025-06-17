part of 'user_bloc.dart';

sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoaded extends UserState {
  final User user;
  UserLoaded(this.user);
}

final class UserLoadFailure extends UserState {
  final String message;
  UserLoadFailure(this.message);
}

final class UserLoading extends UserState {}

final class UserFollowed extends UserState {
  UserFollowed();
}
