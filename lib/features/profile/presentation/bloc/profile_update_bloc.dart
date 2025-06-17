import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sblog/features/auth/domain/entities/user.dart';
import 'package:sblog/features/profile/domain/usecases/profile_usecase.dart';

part 'profile_update_event.dart';
part 'profile_update_state.dart';

class ProfileUpdateBloc extends Bloc<ProfileUpdateEvent, ProfileUpdateState> {
  ProfileUpdateBloc(this.profileUsecase) : super(ProfileInitial()) {
    on<ProfileUpdate>(_onProfileUpdate);
  }

  final ProfileUsecase profileUsecase;

  void _onProfileUpdate(ProfileUpdate event, Emitter<ProfileUpdateState> emit) async {
    try {
      emit(ProfileUpdateLoading());
      final result = await profileUsecase.profileUpdate(event.user);
      log("result: $result");
      result.fold(
        (l) => emit(
         
          ProfileUpdateFailure(),
        ),
        (r) => emit(
          ProfileUpdateSuccess(),
        ),
      );
    } catch (e) {
      emit(ProfileUpdateFailure());
    }
  }

  

}
