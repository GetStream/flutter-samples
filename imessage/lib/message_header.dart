import 'package:flutter/cupertino.dart';

import 'package:imessage/utils.dart';

class MessageHeader extends StatelessWidget {
  final DateTime receivedAt;
  const MessageHeader({Key key, @required this.receivedAt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(formatDate(receivedAt));
  }
}
