import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  static const String _keyUserId = 'session_user_id';
  static const String _keyToken = 'session_token';
  final FlutterSecureStorage _secureStorage;

  const SessionStorage(this._secureStorage);

  Future<void> saveSession(String userId, String token) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_keyUserId, userId);
    await _secureStorage.write(key: _keyToken, value: token);
  }

  Future<String?> getUserId() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_keyUserId);
  }

  Future<String?> getToken() => _secureStorage.read(key: _keyToken);

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_keyUserId);
    await _secureStorage.delete(key: _keyToken);
  }
}
