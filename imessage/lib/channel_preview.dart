import 'package:flutter/cupertino.dart';
import 'package:imessage/channel_image.dart';
import 'package:imessage/channel_name_text.dart';
import 'package:imessage/utils.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    show Channel;

import 'utils.dart';

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
    final lastMessage =
        channel.state.messages.isNotEmpty ? channel.state.messages.last : null;

    final prefix = lastMessage?.attachments != null
        ? lastMessage?.attachments //TODO: ugly
            ?.map((e) {
              if (e.type == 'image') {
                return '📷';
              } else if (e.type == 'video') {
                return '🎬';
              }
              return null;
            })
            ?.where((e) => e != null)
            ?.join(' ')
        : '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: CupertinoColors.white),
        child: GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                ChannelImage(channel: channel, size: 50),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ChannelNameText(
                                channel: channel,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                               isSameWeek(channel.lastMessageAt) ? formatDateSameWeek(channel.lastMessageAt):formatDate(channel.lastMessageAt),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: CupertinoColors.systemGrey),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '$prefix ${lastMessage?.text ?? ''}',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: CupertinoColors.systemGrey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

 
}
