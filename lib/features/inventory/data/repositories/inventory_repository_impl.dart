import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasource/inventory_remote_data_source.dart';
import '../models/product_model.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource dataSource;

  InventoryRepositoryImpl(this.dataSource);

  @override
  Future<List<Product>> getProducts() async {
    final List<ProductModel> models = await dataSource.getProducts();
    return models;
  }

  @override
  Future<Product> addProduct(Product product) async {
    final model = ProductModel(
      id: product.id,
      name: product.name,
      price: product.price,
      stock: product.stock,
    );
    return await dataSource.addProduct(model);
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final model = ProductModel(
      id: product.id,
      name: product.name,
      price: product.price,
      stock: product.stock,
    );
    return await dataSource.updateProduct(model);
  }

  @override
  Future<void> deleteProduct(String id) async => await dataSource.deleteProduct(id);
}