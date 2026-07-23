import '../entities/product_entity.dart';
import '../repositories/inventory_repository.dart';

class AddProductUseCase {
  final InventoryRepository repository;
  AddProductUseCase(this.repository);

  Future<Product> execute(Product product) => repository.addProduct(product);
}
