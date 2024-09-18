import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/category_bloc.dart';
import '../model/category_model.dart';

class CategoryPage extends StatelessWidget {
  final String category;

  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryProductsBloc()..fetchCategoryProducts(category),
      child: Scaffold(
        appBar: AppBar(
          title: Text(category),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
          ),
        ),
        body: BlocBuilder<CategoryProductsBloc, List<Product>>(
          builder: (context, products) {
            if (products.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: CachedNetworkImage(
                      imageUrl: product.image,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(), // Placeholder tijdens laden
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error), // Foutafhandeling
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(product.title),
                  subtitle: Text('\$${product.price.toString()}'),
                  onTap: () {
                    context.go('/product/${product.id}');
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
