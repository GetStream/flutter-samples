
import 'package:flutter/cupertino.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' show Channel;

class ChannelNameText extends StatelessWidget {
  const ChannelNameText({
    Key key,
    @required this.channel,
  }) : super(key: key);

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    
    return Text(
      channel.extraData['name'] as String ?? channel.config.name,
      style: TextStyle(
          fontWeight: FontWeight.bold, color: CupertinoColors.black),
    );
  }
}