import 'package:flutter/cupertino.dart';
import 'package:imessage/message_list_view.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    show MessageListCore, StreamChannel, StreamChatCore;

import 'channel_image.dart';
import 'channel_name_text.dart';

class MessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final streamChannel = StreamChannel.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Column(
          children: [
            ChannelImage(size: 25, channel: streamChannel.channel),
            ChannelNameText(channel: streamChannel.channel)
          ],
        ),
      ), //ChannelHeader
      child: StreamChatCore(
          client: streamChannel.channel.client, child: MessageListCore(
             loadingBuilder: (context) {
           return Center(
             child: CupertinoActivityIndicator(),
           );
         },
         errorWidgetBuilder: (context, err) {
           return Center(
             child: Text('Error'),
           );
           },
             emptyBuilder: (context) {
           return Center(
             child: Text('Nothing here...'),
           );
         },
            messageListBuilder:(context, messages) => MessageListView(messages: messages,))),
    );
  }
}
