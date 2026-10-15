import '../../domain/entities/auth_tokens_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  @override
  Future<AuthTokensEntity> login({
    required String email,
    required String password,
  }) async {
    final tokens = await _remote.login(email: email, password: password);
    await _local.saveTokens(tokens);
    return tokens;
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _remote.register(name: name, email: email, password: password);
  }
}