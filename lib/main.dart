import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/login/data/datasources/remote/auth_remote_data_source.dart';
import 'features/login/data/repositories/auth_repository_impl.dart';
import 'features/login/domain/usecases/auth_usecase.dart';
import 'features/login/presentation/providers/login_view_model.dart';

import 'features/inventory/data/datasource/inventory_mock_data.dart';
import 'features/inventory/data/repositories/inventory_repository_impl.dart';
import 'features/inventory/presentation/providers/inventory_view_model.dart';

import 'app.dart';

void main() {
  final authDataSource = AuthRemoteDataSource();
  final authRepository = AuthRepositoryImpl(authDataSource);
  final authUseCase = AuthUseCase(authRepository);

  final inventoryDataSource = InventoryMockDataSource();
  final inventoryRepository = InventoryRepositoryImpl(inventoryDataSource);

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => LoginViewModel(authUseCase),
          ),
          ChangeNotifierProvider(
            create: (_) => InventoryViewModel(inventoryRepository),
          ),
        ],
        child: const App(),
      ),
    ),
  );
}