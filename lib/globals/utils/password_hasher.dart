import 'dart:convert';

import 'package:crypto/crypto.dart';

class PasswordHasher {
  String hash(String value) {
    final bytes = utf8.encode(value);
    return sha256.convert(bytes).toString();
  }
}
