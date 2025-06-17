import 'package:dartz/dartz.dart';
import 'package:sblog/features/auth/domain/entities/user.dart';

abstract class ProfileRepository {
  Future<Either<String, String>> changePassword({required String newPassword});

  Future<Either<String, String>> updateProfile({required User user});

  Future<Either<String, User>> getProfile({required int userId});

  Future<void> followUser({required int userId, required bool isFollowing});
}
