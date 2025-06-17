part of 'profile_update_bloc.dart';

sealed class ProfileUpdateEvent {}

class ProfileUpdate extends ProfileUpdateEvent {
  final User user;
  ProfileUpdate(this.user);
}
