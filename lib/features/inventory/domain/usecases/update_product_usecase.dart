import '../entities/product_entity.dart';
import '../repositories/inventory_repository.dart';

class UpdateProductUseCase {
  final InventoryRepository repository;
  UpdateProductUseCase(this.repository);

  Future<Product> execute(Product product) => repository.updateProduct(product);
}
