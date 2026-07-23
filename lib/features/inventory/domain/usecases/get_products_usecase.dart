import '../entities/product_entity.dart';
import '../repositories/inventory_repository.dart';

class GetProductsUseCase {
  final InventoryRepository repository;
  GetProductsUseCase(this.repository);

  Future<List<Product>> execute() => repository.getProducts();
}
