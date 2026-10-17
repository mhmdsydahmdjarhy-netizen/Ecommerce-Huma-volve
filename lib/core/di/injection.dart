import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/usecases/get_categories_usecase.dart';
import '../../features/home/domain/usecases/get_product_by_id_usecase.dart';
import '../../features/home/domain/usecases/get_products_usecase.dart';

class Injection {
  Injection._();

  static final _authRepository = AuthRepositoryImpl(
    remote: AuthRemoteDataSource(),
    local: AuthLocalDataSource(),
  );
  static final loginUseCase = LoginUseCase(_authRepository);
  static final registerUseCase = RegisterUseCase(_authRepository);

  static final _homeRepository = HomeRepositoryImpl(HomeRemoteDataSource());
  static final getCategoriesUseCase = GetCategoriesUseCase(_homeRepository);
  static final getProductsUseCase = GetProductsUseCase(_homeRepository);
  static final getProductByIdUseCase = GetProductByIdUseCase(_homeRepository);
}