import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // ✅ جديد

import '../../../core/dummy_data.dart';
import '../../../core/theme.dart';
import '../data/services/home_service.dart'; // ✅ جديد
import '../logic/home_cubit.dart'; // ✅ جديد
import '../logic/home_state.dart'; // ✅ جديد
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';

// ✅ اتغيّرت: بقت بتوفّر الـ Cubit وتحمّل البيانات أول ما تفتح
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(HomeService())..loadHome(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.menu,
                            color: AppTheme.primary,
                          ),
                        ),
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            dummyUser.profilePictureUrl,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Explore',
                      style: Theme.of(context).textTheme.displayLarge
                          ?.copyWith(fontSize: 36),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Best trendy collection!',
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search clothes...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.tune,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // ✅ اتغيّر: الـ chips بتيجي من الـ API عن طريق الـ Cubit
                    BlocBuilder<HomeCubit, HomeState>(
                      buildWhen: (prev, curr) =>
                          prev.categories != curr.categories ||
                          prev.selectedIndex != curr.selectedIndex,
                      builder: (context, state) {
                        final labels = [
                          'All',
                          ...state.categories.map((c) => c.name),
                        ];
                        return SizedBox(
                          height: 44,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: labels.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              return CategoryChip(
                                label: labels[index],
                                isSelected: state.selectedIndex == index,
                                onTap: () => context
                                    .read<HomeCubit>()
                                    .selectCategory(index),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            // ✅ اتغيّر: المنتجات بتتعرض حسب حالة الـ Cubit
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state.status == HomeStatus.loading) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }
                if (state.status == HomeStatus.failure) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            state.errorMessage ?? 'Something went wrong',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () =>
                                context.read<HomeCubit>().loadHome(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (state.products.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(child: Text('No products found')),
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return ProductCard(product: state.products[index]);
                    }, childCount: state.products.length),
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}