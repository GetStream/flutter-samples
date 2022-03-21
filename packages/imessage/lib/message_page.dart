import 'package:flutter/cupertino.dart';
import 'package:imessage/message_list_view.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    show
        LazyLoadScrollView,
        MessageListController,
        MessageListCore,
        StreamChannel,
        StreamChatCore;

import 'package:imessage/channel_image.dart';
import 'package:imessage/channel_name_text.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final streamChannel = StreamChannel.of(context);

    var messageListController = MessageListController();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Column(
          children: [
            ChannelImage(
              size: 32,
              channel: streamChannel.channel,
            ),
            ChannelNameText(
              channel: streamChannel.channel,
              size: 10,
              fontWeight: FontWeight.w300,
            ),
          ],
        ),
      ),
      child: StreamChatCore(
        client: streamChannel.channel.client,
        child: MessageListCore(
          messageListController: messageListController,
          loadingBuilder: (context) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          },
          errorBuilder: (context, err) {
            return const Center(
              child: Text('Error'),
            );
          },
          emptyBuilder: (context) {
            return const Center(
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
          ),
        ),
      ),
    );
  }
}
