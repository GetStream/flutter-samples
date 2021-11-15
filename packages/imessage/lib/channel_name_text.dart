import 'package:flutter/cupertino.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    show Channel;

class ChannelNameText extends StatelessWidget {
  const ChannelNameText({
    Key? key,
    required this.channel,
    this.size = 17,
    this.fontWeight,
  }) : super(key: key);

  final Channel channel;
  final double size;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      channel.extraData['name'] as String? ?? 'No name',
      style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight,
        color: CupertinoColors.black,
      ),
    );
  }
}
