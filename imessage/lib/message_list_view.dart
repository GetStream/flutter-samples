import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:imessage/message_header.dart';
import 'package:imessage/message_input.dart';
import 'package:imessage/message_widget.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    show Message, StreamChatCore;

class MessageListView extends StatelessWidget {
  const MessageListView({Key key, this.messages}) : super(key: key);
  final List<Message> messages;

  @override
  Widget build(BuildContext context) {

    final entries = groupBy(messages.reversed, (Message message) {
      final msgLength = message.updatedAt.toString().length;
      if (msgLength > 4) {
        return message.updatedAt.toString().substring(0, 10);
      }
    }).entries.toList();
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
                    if (index >= entries.length) {
                      return const CupertinoActivityIndicator();
                    }
                    //trick: https://stackoverflow.com/questions/62530799/listview-group-by-date-dart
                    else {
                      return Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 8.0),
                            child: entries[index].key != null //TODO: weird bug
                                ? MessageHeader(
                                    rawTimeStamp: entries[index].key)
                                : Container(), //date
                          ),
                          ...entries[index]
                              .value //messages
                              .map((message) => MessageWidget(
                                  alignment: isReceived(message, context)
                                      ? Alignment.centerLeft
                                      : Alignment.topRight,
                                  color: isReceived(message, context)
                                      ? CupertinoColors.systemGrey5
                                      : CupertinoColors.systemBlue,
                                  messageColor: isReceived(message, context)
                                      ? CupertinoColors.black
                                      : CupertinoColors.white,
                                  message: message.text))
                              .toList()
                        ],
                      );
                    }
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
      message.updatedAt.day == DateTime.now().day;
}
