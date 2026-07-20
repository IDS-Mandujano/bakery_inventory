import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:transactional_app/core/network/supabase_config.dart';
import '../models/product_model.dart';

class InventoryRemoteDataSource {
  final String _table = 'products';

  Future<List<ProductModel>> getProducts() async {
    final response = await http.get(
      Uri.parse('${SupabaseConfig.url}/rest/v1/$_table?select=*'),
      headers: SupabaseConfig.headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener productos (${response.statusCode}): ${response.body}');
    }
  }

  Future<ProductModel> addProduct(ProductModel product) async {
    final response = await http.post(
      Uri.parse('${SupabaseConfig.url}/rest/v1/$_table'),
      headers: {
        ...SupabaseConfig.headers,
        'Prefer': 'return=representation',
      },
      body: jsonEncode({
        'name': product.name,
        'price': product.price,
        'stock': product.stock,
      }),
    );

    if (response.statusCode == 201) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isEmpty) throw Exception('Producto agregado pero no se recibió respuesta del servidor.');
      return ProductModel.fromJson(data.first);
    } else {
      try {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Error al agregar producto (${response.statusCode})');
      } catch (_) {
        throw Exception('Error al agregar producto (${response.statusCode}): ${response.body}');
      }
    }
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await http.patch(
      Uri.parse('${SupabaseConfig.url}/rest/v1/$_table?id=eq.${product.id}'),
      headers: {
        ...SupabaseConfig.headers,
        'Prefer': 'return=representation',
      },
      body: jsonEncode({
        'name': product.name,
        'price': product.price,
        'stock': product.stock,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isEmpty) throw Exception('Producto actualizado pero no se recibió respuesta del servidor.');
      return ProductModel.fromJson(data.first);
    } else {
      try {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Error al actualizar producto (${response.statusCode})');
      } catch (_) {
        throw Exception('Error al actualizar producto (${response.statusCode}): ${response.body}');
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final response = await http.delete(
      Uri.parse('${SupabaseConfig.url}/rest/v1/$_table?id=eq.$id'),
      headers: SupabaseConfig.headers,
    );

    if (response.statusCode != 204) {
      try {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Error al eliminar producto');
      } catch (_) {
        throw Exception('Error al eliminar producto (${response.statusCode})');
      }
    }
  }
}