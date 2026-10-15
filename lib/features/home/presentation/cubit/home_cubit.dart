import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/dummy_data.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../mappers/product_mapper.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetCategoriesUseCase _getCategories;
  final GetProductsUseCase _getProducts;

  HomeCubit({
    required GetCategoriesUseCase getCategories,
    required GetProductsUseCase getProducts,
  })  : _getCategories = getCategories,
        _getProducts = getProducts,
        super(const HomeState());

  Future<void> loadHome() async {
    emit(state.copyWith(status: HomeStatus.loading, selectedIndex: 0));
    try {
      final categories = await _getCategories();
      final products = await _fetchProducts(null);
      emit(state.copyWith(
        status: HomeStatus.success,
        categories: categories,
        products: products,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: _cleanError(e),
      ));
    }
  }

  Future<void> selectCategory(int index) async {
    if (index == state.selectedIndex) return;
    emit(state.copyWith(status: HomeStatus.loading, selectedIndex: index));
    try {
      final categoryId = index == 0 ? null : state.categories[index - 1].id;
      final products = await _fetchProducts(categoryId);
      if (state.selectedIndex != index) return;
      emit(state.copyWith(status: HomeStatus.success, products: products));
    } catch (e) {
      if (state.selectedIndex != index) return;
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: _cleanError(e),
      ));
    }
  }

  Future<List<Product>> _fetchProducts(int? categoryId) async {
    final entities = await _getProducts(categoryId: categoryId);
    return entities.map((e) => e.toProduct()).toList();
  }

  String _cleanError(Object e) => e.toString().replaceFirst('Exception: ', '');
}