import 'package:get_it/get_it.dart';
import '../data/datasource/inventory_remote_data_source.dart';
import '../data/repositories/inventory_repository_impl.dart';
import '../domain/repositories/inventory_repository.dart';
import '../domain/usecases/get_products_usecase.dart';
import '../domain/usecases/add_product_usecase.dart';
import '../domain/usecases/update_product_usecase.dart';
import '../domain/usecases/delete_product_usecase.dart';
import '../presentation/providers/inventory_view_model.dart';

final sl = GetIt.instance;

void initInventory() {
  sl.registerLazySingleton(() => InventoryRemoteDataSource());

  sl.registerLazySingleton<InventoryRepository>(() => InventoryRepositoryImpl(sl()));

  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => AddProductUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProductUseCase(sl()));

  sl.registerFactory(() => InventoryViewModel(
        getProductsUseCase: sl(),
        addProductUseCase: sl(),
        updateProductUseCase: sl(),
        deleteProductUseCase: sl(),
      ));
}
