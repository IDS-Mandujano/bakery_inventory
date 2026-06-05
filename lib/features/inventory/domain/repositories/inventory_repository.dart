import '../entities/product_entity.dart';

abstract class InventoryRepository {
  Future<List<Product>> getProducts();
  Future<Product> addProduct(Product product);
  Future<Product> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}