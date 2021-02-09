import 'package:flutter/cupertino.dart';
import 'package:imessage/channel_preview.dart';
import 'package:imessage/message_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    show Channel, StreamChannel;

class ChannelListView extends StatelessWidget {
  const ChannelListView({
    Key key,
    @required this.channelsStates
  }) : super(key: key);
  final List<Channel> channelsStates;
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Column(
            children: [
              ChannelPreview(onTap: () {//StreamChannel(
                           // channel: channelsStates[index],
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
