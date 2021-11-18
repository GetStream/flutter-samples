import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

String formatDate(DateTime date) {
  final dateFormat = DateFormat.yMd();
  return dateFormat.format(date);
}

String formatDateSameWeek(DateTime date) {
  DateFormat dateFormat;
  if (date.day == DateTime.now().day) {
    dateFormat = DateFormat('hh:mm a');
  } else {
    dateFormat = DateFormat('EEEE');
  }
  return dateFormat.format(date);
}

String formatDateMessage(DateTime date) {
  final dateFormat = DateFormat('EEE. MMM. d ' 'yy' '  hh:mm a');
  return dateFormat.format(date);
}

bool isSameWeek(DateTime timestamp) =>
    DateTime.now().difference(timestamp).inDays < 7;

class CupertinoCircleAvatar extends StatelessWidget {
  final String? url;
  final double? size;
  const CupertinoCircleAvatar({Key? key, this.url, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size! / 2),
      child: CachedNetworkImage(
          imageUrl: url!,
          height: size,
          width: size,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) {
            //TODO: this crash the app when getting 404 and in debug mode, see :https://github.com/Baseflow/flutter_cached_network_image/issues/504
            return CachedNetworkImage(
              imageUrl:
                  'https://4.bp.blogspot.com/-Jx21kNqFSTU/UXemtqPhZCI/AAAAAAAAh74/BMGSzpU6F48/s1600/funny-cat-pictures-047-001.jp',
            );
          }),
    );
  }
}

class Divider extends StatelessWidget {
  const Divider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 1,
          color: CupertinoColors.systemGrey5,
        ),
      ),
    );
  }
}
