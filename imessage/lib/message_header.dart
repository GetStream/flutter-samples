import 'package:flutter/cupertino.dart';

import 'utils.dart';

class MessageHeader extends StatelessWidget {
  final DateTime receivedAt;
  const MessageHeader({Key key, @required this.receivedAt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'iMessage',
          style: TextStyle(color: CupertinoColors.systemGrey),
        ),
        Text(formatDate(receivedAt)) //formatDate(receivedAt)
      ],
    );
  }
}
