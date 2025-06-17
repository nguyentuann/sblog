import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:sblog/features/auth/data/sources/api/auth_api.dart';
import 'package:sblog/core/util/local_data.dart';
import 'package:sblog/features/auth/domain/entities/user.dart';
import 'package:sblog/features/auth/domain/repositories/auth_repository.dart';
import 'package:sblog/service_locator.dart';

class AuthRepositoryImpl implements AuthRepository {
  final authAPI = sl<AuthAPI>();
  final localData = sl<LocalData>();

  @override
  Future<Either<String, User>> login(String email, String password) async {
    try {
      final response = await authAPI.login(email, password);
      await localData.saveAuthData(
        response.accessToken!,
        response.refreshToken!,
        response.id,
      );
      return Right(response.toEntity());
    } catch (e) {
      return const Left("Login Failed!");
    }
  }

  @override
  Future<Either<String, void>> logout() async {
    try {
      final refreshToken = localData.getRefreshToken();
      await authAPI.logout(refreshToken!);
      await localData.clearAuthData();
      return const Right(null);
    } catch (e) {
      return const Left("Logout Failed!");
    }
  }

  @override
  Future<Either<String, User>> register(
      String firstname, String lastname, String email, String password) async {
    try {
      final response =
          await authAPI.register(firstname, lastname, email, password);
      await localData.saveAuthData(
        response.accessToken!,
        response.refreshToken!,
        response.id,
      );
      return Right(response.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> refreshToken() async {
    try {
      final accessToken = localData.getAccessToken();
      log("Access Token: $accessToken");
      if (accessToken == null) {
        return const Left("Token Null!");
      } else {
        final refreshToken = localData.getRefreshToken();
        log("Refresh Token: $refreshToken");
        final response = await authAPI.refreshToken(refreshToken!);
        await localData.saveAuthData(
          response['accessToken']!,
          response['refreshToken']!,
          localData.getUserId()!,
        );
      }
      return Right("Token Refreshed!");
    } catch (e) {
      return const Left("Authenticate Failed!");
    }
  }
}
