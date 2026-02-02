import 'dart:math';

class TokenGenerator {
  static const int _length = 32;
  static const int _alphabetLength = 26;
  final Random _random = Random();

  String generate() {
    final buffer = StringBuffer();
    for (var index = 0; index < _length; index += 1) {
      final charCode = 'a'.codeUnitAt(0) + _random.nextInt(_alphabetLength);
      buffer.write(String.fromCharCode(charCode));
    }
    return buffer.toString();
  }
}
