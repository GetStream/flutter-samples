import 'package:flutter/cupertino.dart';
import 'package:imessage/channel_preview.dart';
import 'package:imessage/message_page.dart';
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
        (BuildContext context, int index) {
          //TODO: separators
          return Column(
            children: [
              ChannelPreview(
                  channel: channels[index],
                  onTap: () {
                    //TODO:transition animation
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => StreamChannel(
                                channel: channels[index],
                                child: MessagePage(),
                              )),
                    );
                  })
            ],
          );
        },
        childCount: channels.length,
      ),
    );
  }
}
