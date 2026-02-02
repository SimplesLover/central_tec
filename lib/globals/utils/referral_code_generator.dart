import 'dart:math';

import '../constants/app_constants.dart';

class ReferralCodeGenerator {
  static const int _lettersCount = 3;
  static const int _alphabetLength = 26;
  final Random _random = Random();

  String generate() {
    final year = DateTime.now().year;
    final letters = _randomLetters();
    return '${AppConstants.referralPrefix}$year$letters';
  }

  String _randomLetters() {
    final buffer = StringBuffer();
    for (var index = 0; index < _lettersCount; index += 1) {
      final charCode = 'A'.codeUnitAt(0) + _random.nextInt(_alphabetLength);
      buffer.write(String.fromCharCode(charCode));
    }
    return buffer.toString();
  }
}
