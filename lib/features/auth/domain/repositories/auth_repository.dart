import '../entities/auth_tokens_entity.dart';

abstract class AuthRepository {
  Future<AuthTokensEntity> login({
    required String email,
    required String password,
  });

  Future<void> register({
    required String name,
    required String email,
    required String password,
  });
}