part of 'profile_bloc.dart';

sealed class ProfileEvent {}

class ProfileGet extends ProfileEvent {
  final int userId;
  ProfileGet(this.userId);
}

class ChangePassword extends ProfileEvent {
  final String newPassword;
  ChangePassword(this.newPassword);
}


class UserGet extends ProfileEvent {
  final int userId;
  UserGet(this.userId);
}
