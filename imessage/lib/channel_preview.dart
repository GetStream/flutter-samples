import 'package:flutter/cupertino.dart';
import 'package:imessage/channel_image.dart';
import 'package:imessage/channel_name_text.dart';
import 'package:imessage/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    show Channel, StreamChannel;

class ChannelPreview extends StatelessWidget {
  final VoidCallback onTap;
  final Channel channel;
  // final Contact from;
  const ChannelPreview({
    Key key,
    @required this.onTap,
    @required this.channel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lastMessage = channel.state.messages.isNotEmpty
        ? channel.state.messages.last
        : null;
    final prefix = lastMessage.attachments
        .map((e) {
          if (e.type == 'image') {
            return '📷';
          } else if (e.type == 'video') {
            return '🎬';
          }
          return null;
        })
        .where((e) => e != null)
        .join(' ');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: CupertinoColors.white),
        child: CupertinoListTile(
          onTap: onTap,
          // shape: RoundedRectangleBorder(),

          leading: ChannelImage(channel: channel),
          title: ChannelNameText(channel: channel),
          trailing: Text(
            formatDate(channel.lastMessageAt),
            style: TextStyle(
                fontWeight: FontWeight.bold, color: CupertinoColors.systemGrey),
          ),
          subtitle: Text(
            '$prefix ${lastMessage.text ?? ''}',
            style: TextStyle(
                fontWeight: FontWeight.normal,
                color: CupertinoColors.systemGrey),
          ),
        ),
      ),
    );
  }
}
