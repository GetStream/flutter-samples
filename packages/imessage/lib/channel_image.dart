import 'package:flutter/cupertino.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    show Channel;

import 'package:imessage/utils.dart';

class ChannelImage extends StatelessWidget {
  const ChannelImage({
    Key? key,
    required this.channel,
    required this.size,
  }) : super(key: key);

  final Channel channel;
  final double size;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = channel.extraData.containsKey('image') &&
            (channel.extraData['image'] as String).isNotEmpty
        ? channel.extraData['image'] as String?
        : 'https://4.bp.blogspot.com/-Jx21kNqFSTU/UXemtqPhZCI/AAAAAAAAh74/BMGSzpU6F48/s1600/funny-cat-pictures-047-001.jpg';

    return CupertinoCircleAvatar(
      size: size,
      url: avatarUrl,
    );
  }
}
