part of 'user_bloc.dart';

sealed class UserEvent {}

class UserGet extends UserEvent {
  final int userId;
  UserGet(this.userId);
}

class UserFollow extends UserEvent {
  final int userId;
  final bool isFollowing;
  UserFollow(this.userId, this.isFollowing);
}
