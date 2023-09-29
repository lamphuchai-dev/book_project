
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'constants/secures.dart';

class SecureStorage {
  const SecureStorage(this._storage);

  final FlutterSecureStorage _storage;

  

  ///set auth access token
  Future<void> setExpiresInToken(String token) async =>
      await _storage.write(key: Secures.expiresIn, value: token);
  Future<String?> get expiresInToken async =>
      await _storage.read(key: Secures.expiresIn);

  ///set auth access token
  Future<void> setAccessToken(String token) async =>
      await _storage.write(key: Secures.accessToken, value: token);

  /// get auth access token.
  Future<String?> get accessToken async =>
      await _storage.read(key: Secures.accessToken);

  ///get auth refresh token
  Future<String?> get refreshToken async =>
      await _storage.read(key: Secures.refreshToken);

  ///set auth refresh token
  Future<void> setRefreshToken(String token) async =>
      await _storage.write(key: Secures.refreshToken, value: token);

  Future<void> clearAll() async => await _storage.deleteAll();
}
