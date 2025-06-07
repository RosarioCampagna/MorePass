import 'package:web/web.dart' as web;
import 'secure_storage_service.dart';

class WebStorageService implements SecureStorageService {
  @override
  Future<void> write(String key, String value) async {
    web.window.localStorage.setItem(key, value);
  }

  @override
  Future<String?> read(String key) async {
    return web.window.localStorage.getItem(key);
  }

  @override
  Future<void> delete(String key) async {
    web.window.localStorage.removeItem(key);
  }
}

WebStorageService createStorageService() => WebStorageService();
