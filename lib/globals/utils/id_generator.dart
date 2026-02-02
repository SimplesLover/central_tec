import 'dart:math';

class IdGenerator {
  static const int _suffixBase = 900000;
  static const int _suffixOffset = 100000;
  final Random _random = Random();

  String generate() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final suffix = _random.nextInt(_suffixBase) + _suffixOffset;
    return '$timestamp$suffix';
  }
}
