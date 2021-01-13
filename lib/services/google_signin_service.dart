import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final _storage = new FlutterSecureStorage();

class GoogleSignInServices {
  static Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }
}
