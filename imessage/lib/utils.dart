import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

String formatDate(DateTime date) {
  final dateFormat = DateFormat.yMd().add_jm();
  return dateFormat.format(date);
}

String formatDateSameWeek(DateTime date) {
  final dateFormat = DateFormat('EEEE, hh:mm a'); //mer. 20 janv. à 15:31
  return dateFormat.format(date);
}

String formatDateMessage(DateTime date) {
  final dateFormat =
      DateFormat('EEE. MMM. d ' 'yy' '  hh:mm a'); //mer. 20 janv. à 15:31
  return dateFormat.format(date);
}

 bool isSameWeek(DateTime timestamp ) => DateTime.now().difference(timestamp).inDays < 7;


class CupertinoCircleAvatar extends StatelessWidget {
  final String url;
  final double size;
  const CupertinoCircleAvatar({Key key, this.url, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Image.network(
        url,
        height: size,
        width: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
