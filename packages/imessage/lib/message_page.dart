import 'package:flutter/cupertino.dart';
import 'package:imessage/message_list_view.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    show
        LazyLoadScrollView,
        MessageListController,
        MessageListCore,
        StreamChannel,
        StreamChatCore;

import 'package:imessage/channel_image.dart';
import 'package:imessage/channel_name_text.dart';

class MessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final streamChannel = StreamChannel.of(context);

    var messageListController = MessageListController();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Column(
          children: [
            ChannelImage(
              size: 25,
              channel: streamChannel.channel,
            ),
            ChannelNameText(
              size: 16,
              channel: streamChannel.channel,
            ),
          ],
        ),
      ), //ChannelHeader
      child: StreamChatCore(
          client: streamChannel.channel.client,
          child: MessageListCore(
              messageListController: messageListController,
              loadingBuilder: (context) {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              },
              errorBuilder: (context, err) {
                return Center(
                  child: Text('Error'),
                );
              },
              emptyBuilder: (context) {
                return Center(
                  child: Text('Nothing here...'),
                );
              },
              messageListBuilder: (context, messages) => LazyLoadScrollView(
                    onStartOfPage: () async {
                      await messageListController.paginateData!();
                    },
                    child: MessageListView(
                      messages: messages,
                    ),
                  ))),
    );
  }
}
