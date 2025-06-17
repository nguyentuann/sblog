import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sblog/features/auth/domain/entities/user.dart';
import 'package:sblog/features/profile/domain/usecases/profile_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this.profileUsecase) : super(ProfileInitial()) {
    on<ProfileGet>(_onGetProfile);
    on<ChangePassword>(_onChangePassword);
  }

  final ProfileUsecase profileUsecase;

 

  void _onChangePassword(
      ChangePassword event, Emitter<ProfileState> emit) async {
    try {
      final result = await profileUsecase.changePassword(event.newPassword);
      result.fold(
        (l) => emit(
          ChangePasswordFailure(),
        ),
        (r) => emit(
          ChangePasswordSuccess(),
        ),
      );
    } catch (e) {
      emit(ChangePasswordFailure());
    }
  }

  void _onGetProfile(ProfileGet event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final result = await profileUsecase.getProfile(event.userId);
      result.fold(
        (l) => emit(
          ProfileLoadFailure(l),
        ),
        (r) => emit(
          ProfileLoaded(r),
        ),
      );
    } catch (e) {
      emit(ProfileLoadFailure(""));
    }
  }

}
