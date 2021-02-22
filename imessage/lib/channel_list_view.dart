import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imessage/channel_preview.dart';
import 'package:imessage/message_page.dart';
import 'package:animations/animations.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    show Channel, StreamChannel;

class ChannelListView extends StatelessWidget {
  const ChannelListView({Key key, @required this.channels}) : super(key: key);
  final List<Channel> channels;
  @override
  Widget build(BuildContext context) {
    channels.removeWhere((channel) => channel.lastMessageAt == null);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (
          BuildContext context,
          int index,
        ) {
          return ChannelPreview(
            channel: channels[index],
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => StreamChannel(
                    channel: channels[index],
                    child: MessagePage(),
                  ),
                  transitionsBuilder: (
                    _,
                    animation,
                    secondaryAnimation,
                    child,
                  ) =>
                      SharedAxisTransition(
                    child: child,
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.horizontal,
                  ),
                ),
              );
            },
          );
        },
        childCount: channels.length,
      ),
    );
  }
}
