part of 'profile_bloc.dart';

sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final User user;
  ProfileLoaded(this.user);
}

final class ProfileLoading extends ProfileState {}

final class ProfileLoadFailure extends ProfileState {
  final String message;
  ProfileLoadFailure(this.message);
}


final class ChangePasswordSuccess extends ProfileState {}

final class ChangePasswordFailure extends ProfileState {}


final class UserLoaded extends ProfileState {
  final User user;
  UserLoaded(this.user);
}

final class UserLoadFailure extends ProfileState {
  final String message;
  UserLoadFailure(this.message);
}

final class UserLoading extends ProfileState {}