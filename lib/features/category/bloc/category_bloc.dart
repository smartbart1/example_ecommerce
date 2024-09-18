import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/category_model.dart';

class CategoryProductsBloc extends Cubit<List<Product>> {
  CategoryProductsBloc() : super([]);

  // Cache key for storing products by category
  String _getCacheKey(String category) => 'category_products_$category';

  // Fetch category products, first checking the cache
  Future<void> fetchCategoryProducts(String category) async {
    try {
      // Try to load from cache first
      final cachedProducts = await _loadFromCache(category);
      if (cachedProducts != null) {
        emit(cachedProducts);
      } else {
        // If no cache found, load from API
        final response = await Dio()
            .get('https://fakestoreapi.com/products/category/$category');
        final products = List<Product>.from(
            response.data.map((json) => Product.fromJson(json)));

        // Emit and cache the products
        emit(products);
        await _saveToCache(category, products);
      }
    } catch (e) {
      emit([]); // On error, emit an empty list
    }
  }

  // Save products to cache
  Future<void> _saveToCache(String category, List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final productList = products.map((product) => product.toJson()).toList();
    prefs.setString(_getCacheKey(category), jsonEncode(productList));
  }

  // Load products from cache
  Future<List<Product>?> _loadFromCache(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = prefs.getString(_getCacheKey(category));

    if (cacheData != null) {
      final List<dynamic> productListJson = jsonDecode(cacheData);
      return productListJson.map((json) => Product.fromJson(json)).toList();
    }
    return null; // No cache found
  }
}
