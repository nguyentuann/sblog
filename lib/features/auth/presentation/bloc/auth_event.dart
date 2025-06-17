part of 'auth_bloc.dart';

class AuthEvent {}

// class AuthStarted extends AuthEvent {}

class AuthLoginStarted extends AuthEvent {
  AuthLoginStarted({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

// xác thực
class AuthAuthenticateStarted extends AuthEvent {}

// đăng ký
class AuthRegisterStarted extends AuthEvent {
  final String firstname;
  final String lastname;
  final String email;
  final String password;

  AuthRegisterStarted({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
  });
}

// đăng xuất
class AuthLogoutStarted extends AuthEvent {}


