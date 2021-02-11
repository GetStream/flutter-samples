import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:imessage/message_header.dart';
import 'package:imessage/message_input.dart';
import 'package:imessage/message_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    show Message, StreamChannel, StreamChat, StreamChatCore, User;

class MessageListView extends StatefulWidget {
  const MessageListView({
    Key key,
  }) : super(key: key);
  @override
  _MessageListViewState createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  StreamSubscription _streamListener;
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();

    final streamChannel = StreamChannel.of(context);

    final stream = streamChannel.channelStateStream.map((c) => c.messages);

    _streamListener = stream.listen((newMessages) {
      newMessages = newMessages.reversed.toList();
      if (_messages.isEmpty || newMessages.first.id != _messages.first.id) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _messages = newMessages;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Align(
          alignment: FractionalOffset.topCenter,
          child: ListView(
            shrinkWrap: true,
            children: [
              ..._messages //TODO: oder by
                  .map((message) => Column(
                        children: [
                          MessageHeader(
                            receivedAt: message.updatedAt,
                          ),
                          MessageWidget(
                              alignment: isReceived(message)
                                  ? Alignment.centerLeft
                                  : Alignment.topRight,
                              color: isReceived(message)
                                  ? CupertinoColors.systemGrey5
                                  : CupertinoColors.systemBlue,
                              messageColor: isReceived(message)
                                  ? CupertinoColors.black
                                  : CupertinoColors.white,
                              message: message.text)
                        ],
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
      MessageInput()
    ]);
  }

  bool isReceived(Message message) {
    final currentUserId = StreamChatCore.of(context).user.id;
    return message.user.id == currentUserId;
  }

  @override
  void dispose() {
    _streamListener.cancel();
    super.dispose();
  }
}
