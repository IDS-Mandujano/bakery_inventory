import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:transactional_app/features/login/data/datasources/remote/auth_remote_data_source.dart';
import 'package:transactional_app/features/login/data/repositories/auth_repository_impl.dart';
import 'package:transactional_app/features/login/domain/usecases/auth_usecase.dart';
import 'package:transactional_app/features/login/presentation/providers/login_view_model.dart';

import 'package:transactional_app/features/inventory/data/datasource/inventory_remote_data_source.dart';
import 'package:transactional_app/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:transactional_app/features/inventory/presentation/providers/inventory_view_model.dart';

import 'package:transactional_app/app.dart';

void main() {
  final authDataSource = AuthRemoteDataSource();
  final authRepository = AuthRepositoryImpl(authDataSource);
  final authUseCase = AuthUseCase(authRepository);

  final inventoryDataSource = InventoryRemoteDataSource();
  final inventoryRepository = InventoryRepositoryImpl(inventoryDataSource);

  runApp(
    DevicePreview(
      enabled: kIsWeb && !kReleaseMode,
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