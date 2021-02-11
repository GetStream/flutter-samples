import 'package:flutter/cupertino.dart';
import 'package:imessage/channel_preview.dart';
import 'package:imessage/message_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    show Channel, StreamChannel;

class ChannelListView extends StatelessWidget {
  const ChannelListView({Key key, @required this.channelsStates})
      : super(key: key);
  final List<Channel> channelsStates;
  @override
  Widget build(BuildContext context) {
    channelsStates.removeWhere((channel) => channel.lastMessageAt == null);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          //TODO: separators
          return Column(
            children: [
              ChannelPreview(
                  channel: channelsStates[index],
                  onTap: () {
                    //TODO:transition animation
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => StreamChannel(
                                channel: channelsStates[index],
                                child: MessagePage(),
                              )),
                    );
                  })
            ],
          );
        },
        childCount: channelsStates.length,
      ),
    );
  }
}
