import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:imessage/message_header.dart';
import 'package:imessage/message_input.dart';
import 'package:imessage/message_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    show Message, StreamChatCore;

class MessageListView extends StatelessWidget {
  const MessageListView({Key key, this.messages}) : super(key: key);
  final List<Message> messages;

  @override
  Widget build(BuildContext context) {
    final entries = groupBy(messages.reversed,
            (Message message) => message.createdAt.toString().substring(0, 10))
        .entries
        .toList();
    return Stack(
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Align(
              alignment: FractionalOffset.topCenter,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: entries.length,
                  itemBuilder: (context, index) {

                    return Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 8.0),
                          child: MessageHeader(
                              rawTimeStamp: entries[index].key), //date
                        ),
                        ...entries[index].value //messages
                            .map((message) {
                          return MessageWidget(
                            alignment: isReceived(message, context)
                                ? Alignment.centerLeft
                                : Alignment.topRight,
                            color: isReceived(message, context)
                                ? CupertinoColors.systemGrey5
                                : CupertinoColors.systemBlue,
                            messageColor: isReceived(message, context)
                                ? CupertinoColors.black
                                : CupertinoColors.white,
                            message: message,
                          );
                        }).toList()
                      ],
                    );
                  }),
            )),
        MessageInput()
      ],
    );
  }

  bool isReceived(Message message, BuildContext context) {
    final currentUserId = StreamChatCore.of(context).user.id;
    return message.user.id == currentUserId;
  }

  bool isSameDay(Message message) =>
      message.createdAt.day == DateTime.now().day;
}
