import 'package:equatable/equatable.dart';

abstract class BaseState<T> extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => [];
}

class InitialState<T> extends BaseState<T> {
  const InitialState();

  @override
  List<Object?> get props => [];
}

class LoadingState<T> extends BaseState<T> {
  const LoadingState();

  @override
  List<Object?> get props => [];
}

class SuccessState<T> extends BaseState<T> {
  final T data;

  const SuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class FailureState<T> extends BaseState<T> {
  final String message;

  const FailureState(this.message);

  @override
  List<Object?> get props => [message];
}
