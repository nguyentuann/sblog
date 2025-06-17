import 'package:dartz/dartz.dart';
import 'package:sblog/core/usecase/usecase.dart';
import 'package:sblog/features/auth/domain/entities/user.dart';
import 'package:sblog/features/auth/domain/repositories/auth_repository.dart';
import 'package:sblog/service_locator.dart';

class LoginUseCase extends Usecase<Either<String, User>, Map<String, String>> {
  @override
  Future<Either<String, User>> call(
      {required Map<String, String> params}) async {
    return sl<AuthRepository>().login(
      params['email']!,
      params['password']!,
    );
  }
}
