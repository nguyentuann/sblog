import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sblog/features/auth/domain/entities/user.dart';
import 'package:sblog/features/profile/domain/usecases/profile_usecase.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(this.profileUsecase) : super(UserInitial()) {
    on<UserGet>(_onGetUser);
    on<UserFollow>(_onFollowUser);
  }

  final ProfileUsecase profileUsecase;

  void _onGetUser(UserGet event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final userId = event.userId;
      final result = await profileUsecase.getProfile(userId);
      result.fold(
        (l) => emit(
          UserLoadFailure(l),
        ),
        (r) => emit(
          UserLoaded(r),
        ),
      );
    } catch (e) {
      emit(UserLoadFailure(e.toString()));
    }
  }

  void _onFollowUser(UserFollow event, Emitter<UserState> emit) async {
    try {
      final userId = event.userId;
      final isFollowing = event.isFollowing;
      await profileUsecase.followUser(userId, isFollowing);
      emit(UserFollowed());
    } catch (e) {
      log('Error following user: $e');
    }
  }
}
