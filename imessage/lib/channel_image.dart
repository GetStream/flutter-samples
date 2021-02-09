
import 'package:flutter/cupertino.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'show Channel;

import 'utils.dart';

class ChannelImage extends StatelessWidget {
  const ChannelImage({
    Key key,
    @required this.channel,
  }) : super(key: key);

 final Channel channel;

  @override
  Widget build(BuildContext context) {
    return CupertinoCircleAvatar(
      size: 50,
      url: channel.extraData['image'] as String,
    );
  }
}
