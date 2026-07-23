import 'package:get_it/get_it.dart';
import '../data/datasources/remote/auth_remote_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/register_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../presentation/providers/login_view_model.dart';

final sl = GetIt.instance;

void initLogin() {
  sl.registerLazySingleton(() => AuthRemoteDataSource());

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  sl.registerFactory(() => LoginViewModel(
        loginUseCase: sl(),
        registerUseCase: sl(),
        logoutUseCase: sl(),
      ));
}
