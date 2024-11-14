import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const tokenKey = 'JWT_TOKEN';

  SharedPreferences? _storage;

  Future<SharedPreferences> get storage async {
    _storage ??= await SharedPreferences.getInstance();
    return _storage!;
  }

  Future<String?> get token async => (await storage).getString(tokenKey);

  Future<void> setToken(String token) async =>
      (await storage).setString(tokenKey, token);

  Future<void> deleteToken() async => (await storage).remove(tokenKey);
}
