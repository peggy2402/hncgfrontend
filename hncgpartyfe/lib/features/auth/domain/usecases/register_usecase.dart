import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String fullname,
    required String username,
    required String email,
    required String password,
    required String gender,
    DateTime? birthdate,
  }) {
    return repository.register(
      fullname: fullname,
      username: username,
      email: email,
      password: password,
      gender: gender,
      birthdate: birthdate,
    );
  }
}
