import 'package:dartz/dartz.dart';
import 'package:sblog/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<String, User>> login(
    String email,
    String password,
  );

  Future<Either<String, User>> register(
    String firstname,
    String lastname,
    String password,
    String email,
  );

  Future<Either<String, void>> logout();

  Future<Either<String, String>> refreshToken();
}
