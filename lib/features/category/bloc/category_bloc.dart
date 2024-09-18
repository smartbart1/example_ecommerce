import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/category_model.dart';

class CategoryProductsBloc extends Cubit<List<Product>> {
  CategoryProductsBloc() : super([]);

  String _getCacheKey(String category) => 'category_products_$category';

  Future<void> fetchCategoryProducts(String category) async {
    try {
      final cachedProducts = await _loadFromCache(category);
      if (cachedProducts != null) {
        emit(cachedProducts);
        return;
      }

      final response = await Dio()
          .get('https://fakestoreapi.com/products/category/$category');
      final products = List<Product>.from(
          response.data.map((json) => Product.fromJson(json)));

      emit(products);
      await _saveToCache(category, products);
    } catch (e) {
      emit([]);
    }
  }

  Future<void> _saveToCache(String category, List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final productList = products.map((product) => product.toJson()).toList();
    await prefs.setString(_getCacheKey(category), jsonEncode(productList));
  }

  Future<List<Product>?> _loadFromCache(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = prefs.getString(_getCacheKey(category));

    if (cacheData == null) return null;

    final List<dynamic> productListJson = jsonDecode(cacheData);
    return productListJson.map((json) => Product.fromJson(json)).toList();
  }
}
