import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:imessage/message_header.dart';
import 'package:imessage/message_input.dart';
import 'package:imessage/message_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    show Message, StreamChannel;

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
    return ListView(
      shrinkWrap: true,
      children: [
        ..._messages //TODO: oder by
            .map((message) => Column(
              children: [
                MessageHeader(
                  receivedAt: message.updatedAt,
                ),
                MessageWidget(//TODO: handle isReceived
                    alignment: Alignment.centerLeft, //message.isReceived
                    // ? Alignment.centerLeft
                    // : Alignment.topRight,
                    color: CupertinoColors.systemGrey5,
                    // color: message.isReceived
                    //     ? CupertinoColors.systemGrey5
                    //     : CupertinoColors.systemBlue,
                    messageColor: CupertinoColors.black,
                    // messageColor: message
                    //     ? CupertinoColors.black
                    //     : CupertinoColors.white,
                    message: message.text)
              ],
            ))
            .toList(),
        MessageInput()//TODO: make this sticky
      ],
    );
  }

  @override
  void dispose() {
    _streamListener.cancel();
    super.dispose();
  }
}
