import '../repositories/inventory_repository.dart';

class DeleteProductUseCase {
  final InventoryRepository repository;
  DeleteProductUseCase(this.repository);

  Future<void> execute(String id) => repository.deleteProduct(id);
}
