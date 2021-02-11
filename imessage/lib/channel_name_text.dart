import 'package:flutter/cupertino.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' show Channel;

class ChannelNameText extends StatelessWidget {
  const ChannelNameText({Key key, @required this.channel, this.size = 12})
      : super(key: key);

  final Channel channel;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      channel.extraData['name'] as String ?? channel.config.name,
      style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.black),
    );
  }
}
