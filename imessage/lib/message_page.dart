import 'package:flutter/cupertino.dart';
import 'package:imessage/message_list_view.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' show StreamChannel;

import 'utils.dart';

class MessagePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final streamChannel = StreamChannel.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
      middle: Column(
        children: [
          CupertinoCircleAvatar(
              size: 25, url: streamChannel.channel.extraData['image'] as String),
          Expanded(child: Text(streamChannel.channel.extraData['name'] as String))
        ],
      ),
    ),//ChannelHeader
      child: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MessageListView(),
          ),
        ),
      ),
    );
  }
}
