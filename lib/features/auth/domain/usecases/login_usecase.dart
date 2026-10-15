import '../entities/auth_tokens_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<AuthTokensEntity> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}