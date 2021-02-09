import 'package:intl/intl.dart';

String formatDate(DateTime date) {
    final dateFormat = DateFormat.yMd().add_jm(); //mer. 20 janv. à 15:31
    return dateFormat.format(date);
  }