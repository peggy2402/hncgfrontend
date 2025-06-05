import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> register({
    required String fullname,
    required String username,
    required String email,
    required String password,
    required String gender,
    DateTime? birthdate,
  });
}
