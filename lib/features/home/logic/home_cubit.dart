import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/dummy_data.dart';
import '../data/services/home_service.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeService _service;

  HomeCubit(this._service) : super(const HomeState());

  // بتحمّل التصنيفات والمنتجات أول ما الشاشة تفتح (وعند الضغط على Retry)
  Future<void> loadHome() async {
    emit(state.copyWith(status: HomeStatus.loading, selectedIndex: 0));
    try {
      final categories = await _service.getCategories();
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

  // بتتنادى لما المستخدم يضغط على تصنيف (0 = All)
  Future<void> selectCategory(int index) async {
    if (index == state.selectedIndex) return;
    emit(state.copyWith(status: HomeStatus.loading, selectedIndex: index));
    try {
      final categoryId = index == 0 ? null : state.categories[index - 1].id;
      final products = await _fetchProducts(categoryId);
      // لو المستخدم ضغط على تصنيف تاني قبل ما الرد يوصل، نتجاهل الرد ده
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
    final models = await _service.getProducts(categoryId: categoryId);
    return models.map((m) => m.toProduct()).toList();
  }

  String _cleanError(Object e) => e.toString().replaceFirst('Exception: ', '');
}