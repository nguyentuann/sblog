part of 'profile_update_bloc.dart';

sealed class ProfileUpdateState {}

final class ProfileInitial extends ProfileUpdateState {}


final class ProfileUpdateSuccess extends ProfileUpdateState {}

final class ProfileUpdateFailure extends ProfileUpdateState {}

final class ProfileUpdateLoading extends ProfileUpdateState {}


