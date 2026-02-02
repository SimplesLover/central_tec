import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat currency =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  static final DateFormat dateTime = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat date = DateFormat('dd/MM/yyyy');

  const Formatters();
}
