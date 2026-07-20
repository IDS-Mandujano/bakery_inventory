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

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await repository.getProducts();
    } catch (e) {
      _errorMessage = 'Error al cargar productos';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addProduct(String name, double price, int stock) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newProduct = Product(id: '', name: name, price: price, stock: stock);
      final addedProduct = await repository.addProduct(newProduct);
      _products.add(addedProduct);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProduct(String id, String name, double price, int stock) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedProduct = Product(id: id, name: name, price: price, stock: stock);
      final result = await repository.updateProduct(updatedProduct);
      final index = _products.indexWhere((p) => p.id == id);
      if (index != -1) {
        _products[index] = result;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteProduct(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await repository.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}