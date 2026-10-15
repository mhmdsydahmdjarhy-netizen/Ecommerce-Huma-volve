import '../entities/category_entity.dart';
import '../repositories/home_repository.dart';

class GetCategoriesUseCase {
  final HomeRepository _repository;

  GetCategoriesUseCase(this._repository);

  Future<List<CategoryEntity>> call() => _repository.getCategories();
}