import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remote;

  HomeRepositoryImpl(this._remote);

  @override
  Future<List<CategoryEntity>> getCategories() => _remote.getCategories();

  @override
  Future<List<ProductEntity>> getProducts({
    int? categoryId,
    required int offset,
    required int limit,
  }) {
    return _remote.getProducts(
      categoryId: categoryId,
      offset: offset,
      limit: limit,
    );
  }
}
