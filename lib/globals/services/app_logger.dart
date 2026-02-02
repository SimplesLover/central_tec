import 'package:logger/logger.dart';

class AppLogger {
  final Logger _logger = Logger();

  void info(String message) => _logger.i(message);
  void warning(String message) => _logger.w(message);
  void error(String message) => _logger.e(message);
}
