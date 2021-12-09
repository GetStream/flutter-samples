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

  const ChannelPreview({
    Key? key,
    required this.onTap,
    required this.channel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lastMessage = channel.state!.messages.isNotEmpty
        ? channel.state!.messages.last
        : null;

    final prefix = lastMessage?.attachments != null
        ? lastMessage?.attachments
            .map((e) {
              if (e.type == 'image') {
                return '📷 ';
              } else if (e.type == 'video') {
                return '🎬 ';
              }
              return null;
            })
            .where((e) => e != null)
            .join(' ')
        : '';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                child: ChannelImage(
                  channel: channel,
                  size: 46,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChannelNameText(channel: channel),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Row(
                            children: [
                              Text(
                                isSameWeek(channel.lastMessageAt!)
                                    ? formatDateSameWeek(channel.lastMessageAt!)
                                    : formatDate(channel.lastMessageAt!),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 4.0),
                                child: Icon(
                                  CupertinoIcons.chevron_right,
                                  size: 16,
                                  color: CupertinoColors.systemGrey3,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        '$prefix${lastMessage?.text ?? ''}',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: CupertinoColors.systemGrey,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
