import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/dummy_data.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../mappers/product_mapper.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  static const int _pageSize = 10;

  final GetCategoriesUseCase _getCategories;
  final GetProductsUseCase _getProducts;

  HomeCubit({
    required GetCategoriesUseCase getCategories,
    required GetProductsUseCase getProducts,
  })  : _getCategories = getCategories,
        _getProducts = getProducts,
        super(const HomeState());

  // أول تحميل: التصنيفات + أول صفحة منتجات
  Future<void> loadHome() async {
    emit(state.copyWith(
      status: HomeStatus.loading,
      selectedIndex: 0,
      isLoadingMore: false,
      hasReachedEnd: false,
    ));
    try {
      final categories = await _getCategories();
      final products = await _fetchProducts(null, offset: 0);
      emit(state.copyWith(
        status: HomeStatus.success,
        categories: categories,
        products: products,
        hasReachedEnd: products.length < _pageSize,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: _cleanError(e),
      ));
    }
  }

  // تغيير التصنيف: بنبدأ من أول صفحة تاني
  Future<void> selectCategory(int index) async {
    if (index == state.selectedIndex) return;
    emit(state.copyWith(
      status: HomeStatus.loading,
      selectedIndex: index,
      isLoadingMore: false,
      hasReachedEnd: false,
    ));
    try {
      final categoryId = index == 0 ? null : state.categories[index - 1].id;
      final products = await _fetchProducts(categoryId, offset: 0);
      if (state.selectedIndex != index) return;
      emit(state.copyWith(
        status: HomeStatus.success,
        products: products,
        hasReachedEnd: products.length < _pageSize,
      ));
    } catch (e) {
      if (state.selectedIndex != index) return;
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: _cleanError(e),
      ));
    }
  }

  // الـ pagination: بتجيب الصفحة اللي بعدها وتضيفها على الموجود
  Future<void> loadMore() async {
    if (state.status != HomeStatus.success ||
        state.isLoadingMore ||
        state.hasReachedEnd) {
      return;
    }

    final index = state.selectedIndex;
    emit(state.copyWith(isLoadingMore: true));
    try {
      final categoryId = index == 0 ? null : state.categories[index - 1].id;
      final newProducts = await _fetchProducts(
        categoryId,
        offset: state.products.length,
      );
      // لو المستخدم غيّر التصنيف أثناء التحميل، نتجاهل الرد ده
      if (state.selectedIndex != index) return;
      emit(state.copyWith(
        products: [...state.products, ...newProducts],
        isLoadingMore: false,
        hasReachedEnd: newProducts.length < _pageSize,
      ));
    } catch (e) {
      if (state.selectedIndex != index) return;
      // لو فشل، نوقف الـ loader ويقدر يحاول تاني بالسكرول
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<List<Product>> _fetchProducts(
    int? categoryId, {
    required int offset,
  }) async {
    final entities = await _getProducts(
      categoryId: categoryId,
      offset: offset,
      limit: _pageSize,
    );
    return entities.map((e) => e.toProduct()).toList();
  }

  String _cleanError(Object e) => e.toString().replaceFirst('Exception: ', '');
}