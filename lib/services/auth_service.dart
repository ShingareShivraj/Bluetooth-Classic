import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/login_model.dart';
import 'api_endpoints.dart';
import 'api_service.dart';
import '../screens/login_viewmodel.dart';
import '../screens/login_screen.dart';
import '../models/login_model.dart';

class AuthService extends ChangeNotifier {
  static const _sessionKey = 'garam_mug_session_v1';
  final _storage = const FlutterSecureStorage();
  final _api = ApiService();
  LoginModel? _session;
  LoginModel? get session => _session;

  Future<LoginModel> signIn(String user, String password, {required bool remember}) async {
    final response = await _api.login(user.trim(), password);
    final wrapped = response['message'] is Map
        ? Map<String, dynamic>.from(response['message']) : response;
    final payload = wrapped['data'] is Map
        ? Map<String, dynamic>.from(wrapped['data']) : wrapped;
    final keys = payload['key_details'] ?? wrapped['key_details'] ?? response['key_details'];
    final keyMap = keys is Map ? keys : const {};
    final candidate = LoginModel(site: ApiEndpoints.baseUrl,
      user: (payload['user'] ?? wrapped['user'] ?? response['user'] ?? '').toString(),
      apiKey: (keyMap['api_key'] ?? '').toString(),
      apiSecret: (keyMap['api_secret'] ?? '').toString());
    if (!candidate.isValid) {
      throw const ApiException('Login did not return valid API credentials. Check the backend login response.');
    }
    final actualUser = await _api.currentUser(candidate);
    if (actualUser != candidate.user || actualUser == 'Guest') {
      throw const ApiException('Could not verify your login. Please try again.');
    }
    if (remember) {
      await _storage.write(key: _sessionKey, value: jsonEncode(candidate.toJson()));
    } else {
      await _storage.delete(key: _sessionKey);
    }
    _session = candidate;
    notifyListeners();
    return candidate;
  }

  Future<bool> restoreSession() async {
    if (_session != null) return true;
    final stored = await _storage.read(key: _sessionKey);
    if (stored == null) return false;
    LoginModel candidate;
    try {
      candidate = LoginModel.fromJson(Map<String, dynamic>.from(jsonDecode(stored)));
    } catch (_) {
      await _storage.delete(key: _sessionKey);
      return false;
    }
    if (!candidate.isValid || candidate.site != ApiEndpoints.baseUrl) {
      await _storage.delete(key: _sessionKey);
      return false;
    }
    try {
      final user = await _api.currentUser(candidate);
      if (user != candidate.user || user == 'Guest') {
        await signOut();
        return false;
      }
    } on ApiException catch (error) {
      if (error.statusCode == 401 || error.statusCode == 403) {
        await signOut();
        return false;
      }
      rethrow; // A network outage must not erase a saved login.
    }
    _session = candidate;
    notifyListeners();
    return true;
  }

  Future<void> signOut() async {
    await _storage.delete(key: _sessionKey);
    _session = null;
    notifyListeners();
  }
}
