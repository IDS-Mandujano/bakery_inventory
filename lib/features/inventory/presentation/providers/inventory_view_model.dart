import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/inventory_repository.dart';

class InventoryViewModel extends ChangeNotifier {
  final InventoryRepository repository;

  InventoryViewModel(this.repository);

  List<Product> _products = [];
  List<Product> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    _products = await repository.getProducts();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    await repository.deleteProduct(id);
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }

}