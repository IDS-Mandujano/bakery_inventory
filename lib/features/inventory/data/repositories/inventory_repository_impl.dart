import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasource/inventory_mock_data.dart';
import '../models/product_model.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryMockDataSource dataSource;

  InventoryRepositoryImpl(this.dataSource);

  @override
  Future<List<Product>> getProducts() async => await dataSource.getProducts();

  @override
  Future<Product> addProduct(Product product) async {
    final model = ProductModel(id: product.id, name: product.name, price: product.price, stock: product.stock);
    return await dataSource.addProduct(model);
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final model = ProductModel(id: product.id, name: product.name, price: product.price, stock: product.stock);
    return await dataSource.updateProduct(model);
  }

  @override
  Future<void> deleteProduct(String id) async => await dataSource.deleteProduct(id);
}