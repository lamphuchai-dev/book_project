import 'package:dio_client/index.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:u_book/services/extensions_service.dart';
import 'package:u_book/services/database_service.dart';
import 'package:u_book/services/storage_service.dart';

import '../../data/secure_storage/secure_storage.dart';
import '../../data/sharedpref/shared_preference_helper.dart';
import '../../services/extensions_service.dart';
import '../modules/local_module.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerSingletonAsync<SharedPreferences>(
      () => LocalModule.provideSharedPreferences());

  final storage = StorageService();
  await storage.ensureInitialized();
  getIt.registerSingleton(storage);

  getIt.registerSingleton(DioClient());
  final databaseService = DatabaseService();
  await databaseService.ensureInitialized();
  getIt.registerSingleton(databaseService);
  // final extManger = ExtensionsManager(
  //     dioClient: getIt<DioClient>(), databaseService: databaseService);
  // getIt.registerSingleton(extManger);

  // singletons:----------------------------------------------------------------
  getIt.registerSingleton(SecureStorage(LocalModule.provideSecureStorage()));
  getIt.registerSingleton(
      SharedPreferenceHelper(await getIt.getAsync<SharedPreferences>()));

  getIt.registerSingleton(ExtensionsService());
}
