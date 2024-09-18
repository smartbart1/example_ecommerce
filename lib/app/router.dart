import 'package:go_router/go_router.dart';
import '../features/categories/pages/categories_page.dart';
import '../features/category/pages/category_page.dart';
import '../features/product_detail/pages/product_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const CategoriesPage(),
    ),
    GoRoute(
      path: '/category/:category',
      builder: (context, state) {
        final category = state.pathParameters['category'];
        return CategoryPage(category: category!);
      },
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return ProductDetailPage(productId: id!);
      },
    ),
  ],
);
