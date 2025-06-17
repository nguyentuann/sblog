import 'package:dartz/dartz.dart';
import 'package:sblog/core/usecase/usecase.dart';
import 'package:sblog/features/auth/domain/repositories/auth_repository.dart';
import 'package:sblog/service_locator.dart';

class LogoutUsecase extends Usecase<void, None> {
  @override
  Future<Either<String, void>> call({required None params}) async {
    return await sl<AuthRepository>().logout();
  }
}
