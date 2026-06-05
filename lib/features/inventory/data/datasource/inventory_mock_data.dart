import 'dart:math';
import '../models/product_model.dart';

class InventoryMockDataSource {
  final List<ProductModel> _mockDatabase = [
    ProductModel(id: '1', name: 'Concha Vainilla', price: 15.0, stock: 50),
    ProductModel(id: '2', name: 'Cuernito', price: 12.0, stock: 30),
  ];

  Future<List<ProductModel>> getProducts() async {
    await Future.delayed(const Duration(seconds: 1)); // Simula red
    return [..._mockDatabase];
  }

  Future<ProductModel> addProduct(ProductModel product) async {
    await Future.delayed(const Duration(seconds: 1));
    final newProduct = ProductModel(
      id: Random().nextInt(1000).toString(), // Genera ID temporal
      name: product.name,
      price: product.price,
      stock: product.stock,
    );
    _mockDatabase.add(newProduct);
    return newProduct;
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _mockDatabase.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _mockDatabase[index] = product;
      return product;
    }
    throw Exception('Producto no encontrado');
  }

  Future<void> deleteProduct(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockDatabase.removeWhere((p) => p.id == id);
  }
}