import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final String baseUrl;
  final http.Client client;

  AuthRepositoryImpl({
    required this.baseUrl,
    required this.client,
  });

  @override
  Future<Either<Failure, void>> register({
    required String fullname,
    required String username,
    required String email,
    required String password,
    required String gender,
    DateTime? birthdate,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullname': fullname,
          'username': username,
          'email': email,
          'password': password,
          'gender': gender,
          'birthdate': birthdate?.toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(null);
      } else {
        final errorBody = jsonDecode(response.body);
        return Left(
            ServerFailure(errorBody['message'] ?? 'Registration failed'));
      }
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
