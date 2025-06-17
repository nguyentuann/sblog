import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sblog/core/state/bloc_state.dart';
import 'package:sblog/features/auth/domain/entities/user.dart';
import 'package:sblog/features/auth/domain/usecases/authenticate_usecase.dart';
import 'package:sblog/features/auth/domain/usecases/login_usecase.dart';
import 'package:sblog/features/auth/domain/usecases/logout_usecase.dart';
import 'package:sblog/features/auth/domain/usecases/register_usecase.dart';
import 'package:sblog/service_locator.dart';

part 'auth_event.dart';
// part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, BaseState<User?>> {
  AuthBloc() : super(InitialState()) {
    on<AuthLoginStarted>(_onLoginStarted);

    on<AuthRegisterStarted>(_onRegisterStarted);

    on<AuthLogoutStarted>(_onLogoutStarted);

    on<AuthAuthenticateStarted>(_onAuthenticatedStarted);
  }

  final loginUseCase = sl<LoginUseCase>();
  final registerUsecase = sl<RegisterUsecase>();
  final logoutUsecase = sl<LogoutUsecase>();
  final authenticateUsecase = sl<AuthenticateUsecase>();

  Future<void> _onLoginStarted(
      AuthLoginStarted event, Emitter<BaseState<User?>> emit) async {
    emit(LoadingState());
    final result = await loginUseCase.call(
      params: {
        'email': event.email,
        'password': event.password,
      },
    );
    result.fold(
      (failure) => emit(
        FailureState(failure),
      ), // Nếu lỗi, phát trạng thái thất bại
      (user) => emit(
          SuccessState(user)), // Nếu thành công, phát trạng thái thành công
    );
  }

  Future<void> _onRegisterStarted(
      AuthRegisterStarted event, Emitter<BaseState<User?>> emit) async {
    emit(LoadingState());
    final result = await registerUsecase.call(
      params: {
        'firstname': event.firstname,
        'lastname': event.lastname,
        'email': event.email,
        'password': event.password,
      },
    );
    result.fold(
      (failure) => emit(FailureState(failure)),
      (user) => emit(SuccessState(user)),
    );
  }

  Future<void> _onLogoutStarted(
      AuthLogoutStarted event, Emitter<BaseState<User?>> emit) async {
    emit(LoadingState());
    final result = await logoutUsecase.call(params: None());

    result.fold(
      (l) => emit(FailureState(l)),
      (r) => emit(SuccessState(null)),
    );
  }

  Future<void> _onAuthenticatedStarted(
      AuthAuthenticateStarted event, Emitter<BaseState<User?>> emit) async {
    log('goi ham authenticate');
    final result = await authenticateUsecase.call(params: None());
    result.fold(
      (l) => emit(FailureState(l)),
      (r) => emit(SuccessState(null)),
    );
  }
}
