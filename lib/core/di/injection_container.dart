import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../features/inventory/di/inventory_injection.dart';
import '../../features/login/di/login_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => http.Client());

  initInventory();
  initLogin();
}
