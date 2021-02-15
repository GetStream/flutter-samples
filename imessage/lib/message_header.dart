import 'package:flutter/cupertino.dart';

import 'package:imessage/utils.dart';

class MessageHeader extends StatelessWidget {
  final String rawTimeStamp;
  const MessageHeader({Key key, @required this.rawTimeStamp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final receivedAt = DateTime.parse(rawTimeStamp);
    var textStyle = TextStyle(
        fontWeight: FontWeight.bold, color: CupertinoColors.systemGrey);
    return isSameWeek(receivedAt)
        ? Text(
            formatDateSameWeek(receivedAt),
            style: textStyle,
          )
        : Text(
            formatDate(receivedAt),
            style: textStyle,
          );
  }
}
